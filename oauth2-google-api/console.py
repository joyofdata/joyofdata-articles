# https://developers.google.com/analytics/solutions/articles/hello-analytics-api
# https://developers.google.com/api-client-library/python/auth/installed-app
# https://developers.google.com/api-client-library/python/auth/web-app

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
    return service.data().ga().get(
            ids = 'ga:' + profile_id,
            start_date = start_date,
            end_date = end_date,
            metrics = 'ga:' + metric
        ).execute()

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
 
if __name__ == '__main__':
    logging.basicConfig()

    filename_credentials = "credentials.json"
    credentials = read_credentials(filename_credentials)

    if credentials is None or credentials.invalid:
        credentials = acquire_oauth2_credentials()
        write_credentials(filename_credentials, credentials)

    http_auth = credentials.authorize(httplib2.Http())
  
    service = discovery.build('analytics', 'v3', http_auth)
  
    profile_id = get_first_profile_id(service)

    results = query_analytics(service, profile_id, "2014-01-01", "2014-12-31", "users")

    print json.dumps(results, indent=4)
