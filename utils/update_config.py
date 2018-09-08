import argparse
import yaml
import pprint as pp
import os

BASE_URL_YML_KEY = 'url'
API_URL_YML_KEY = 'contact_url'

parser = argparse.ArgumentParser()

parser.add_argument("config", help="The yml config to update", type=str)
parser.add_argument("--base_url", help="The base url used by the website", type=str)
parser.add_argument("--api_url", help="The api url to be used by the website for dynamic content", type=str)
args = parser.parse_args()

doc = {}
if os.path.isfile(args.config):
    with open(args.config, 'r') as rf:
        doc = yaml.load(rf)

    pp.pprint(doc)

    if doc is not None and len(doc) > 1:
        with open(args.config, 'w') as f:
            if args.base_url is not None:
                doc[BASE_URL_YML_KEY] = args.base_url
            if args.api_url is not None:
                doc[API_URL_YML_KEY] = args.api_url
            yaml.dump(doc, f, default_flow_style=False)
else:
    print "Could not open", args.config
