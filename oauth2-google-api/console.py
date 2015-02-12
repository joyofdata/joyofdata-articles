# https://developers.google.com/analytics/solutions/articles/hello-analytics-api
# https://developers.google.com/api-client-library/python/auth/installed-app
# https://developers.google.com/api-client-library/python/auth/web-app

import sys
import json
import webbrowser
import logging

import httplib2
import os.path


from apiclient import discovery
from oauth2client import client
from oauth2client.file import Storage

def get_first_profile_id(service):
    accounts = service.management().accounts().list().execute()

    if accounts.get('items'):
        first_account_id = accounts.get('items')[0].get('id')
        webproperties = service.management().webproperties().list(accountId = first_account_id).execute()
  
        if webproperties.get('items'):
            first_webproperty_id = webproperties.get('items')[0].get('id')
  
            profiles = service.management().profiles().list(
                      accountId = first_account_id,
                      webPropertyId = first_webproperty_id
                  ).execute()
  
            if profiles.get('items')[0].get('id'):
                return profiles.get('items')[0].get('id')
    return None

def query_analytics(service, profile_id, start_date, end_date, metric):
    if profile_id == None or profile_id == "0":
        profile_id = get_first_profile_id(service)

    result = service.data().ga().get(
            ids = 'ga:' + profile_id,
            start_date = start_date,
            end_date = end_date,
            metrics = 'ga:' + metric
        ).execute()

    return result 


def read_credentials(fname):
    if os.path.isfile(fname):
        f = open(fname, "r")
        credentials = client.OAuth2Credentials.from_json(f.read())
        f.close()
    else:
        credentials = None
    return credentials

def write_credentials(fname, credentials):
    f = file(fname, "w")
    f.write(credentials.to_json())
    f.close()

def acquire_oauth2_credentials():
    flow = client.flow_from_clientsecrets(
        'client_secrets_joyofdata.de.api_installed.json',
        scope='https://www.googleapis.com/auth/analytics.readonly',
        redirect_uri='urn:ietf:wg:oauth:2.0:oob')
    
    auth_uri = flow.step1_get_authorize_url()
    webbrowser.open(auth_uri)
    
    auth_code = raw_input('Enter the authentication code: ')
    
    credentials = flow.step2_exchange(auth_code)
    return credentials

def create_service_object(credentials):
    http_auth = httplib2.Http()
    http_auth = credentials.authorize(http_auth)
    service = discovery.build('analytics', 'v3', http_auth)
    return service

def main(credentials_file, profile_id, start_date, end_date, metric):
    logging.basicConfig()

    credentials = read_credentials(credentials_file)

    if credentials is None or credentials.invalid:
        credentials = acquire_oauth2_credentials()
        write_credentials(credentials_file, credentials)

    service = create_service_object(credentials)
 

    results = query_analytics(service, profile_id, start_date, end_date, metric)

    return json.dumps(results, indent=4)


if __name__ == '__main__':
    credentials_file, profile_id, start_date, end_date, metric = sys.argv[1:6]

    print main(credentials_file, profile_id, start_date, end_date, metric)
