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
    """Fetches first profile ID of account."""
    accounts = service.management().accounts().list().execute()

    if accounts.get('items'):
        first_account_id = accounts.get('items')[0].get('id')
        webprops = service.management().webproperties()
        webprops = webprops.list(accountId = first_account_id).execute()
  
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
    """Performes simple query for profile."""
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
    """Reads JSON with credentials from file."""
    if os.path.isfile(fname):
        f = open(fname, "r")
        credentials = client.OAuth2Credentials.from_json(f.read())
        f.close()
    else:
        credentials = None

    return credentials


def write_credentials(fname, credentials):
    """Writes credentials as JSON to file."""
    f = file(fname, "w")
    f.write(credentials.to_json())
    f.close()


def acquire_oauth2_credentials(secrets_file):
    """Flows through OAuth 2.0 authorization process for credentials."""
    flow = client.flow_from_clientsecrets(
        secrets_file,
        scope='https://www.googleapis.com/auth/analytics.readonly',
        redirect_uri='urn:ietf:wg:oauth:2.0:oob')
    
    auth_uri = flow.step1_get_authorize_url()
    webbrowser.open(auth_uri)
    
    auth_code = raw_input('Enter the authentication code: ')
    
    credentials = flow.step2_exchange(auth_code)
    return credentials


def create_service_object(credentials):
    """Creates Service object for credentials."""
    http_auth = httplib2.Http()
    http_auth = credentials.authorize(http_auth)
    service = discovery.build('analytics', 'v3', http_auth)
    return service


def oauth2_and_query_analytics(
        credentials_file, secrets_file, profile_id, 
        start_date, end_date, metric):
    logging.basicConfig()
    """Performs authorization and then queries GA."""

    credentials = read_credentials(credentials_file)

    if credentials is None or credentials.invalid:
        credentials = acquire_oauth2_credentials(secrets_file)
        write_credentials(credentials_file, credentials)

    service = create_service_object(credentials)
    results = query_analytics(service, profile_id, start_date, end_date, metric)

    return json.dumps(results, indent=4)



if __name__ == '__main__':
    profile_id, start_date, end_date, metric = sys.argv[1:5]

    credentials_file = "credentials.json"
    secrets_file = "client_secrets.json"

    print oauth2_and_query_analytics(
            credentials_file, secrets_file, profile_id, 
            start_date, end_date, metric)
