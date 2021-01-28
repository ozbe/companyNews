#!/bin/bash
#
# View static assets
#   Configured to run from project root
#
# Dependencies
#   open
#   terraform
#

CDN_IP=$(terraform -chdir=terraform output company_news_cdn_ip | tr -d '"')
open "http://$CDN_IP/index.html"