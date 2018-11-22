require 'notify_aws_cost'

#export SLACK_WEBHOOK_URL='......'
#export NOTIFY_MAIL_ADDR='......'
#export GMAIL_ADDR='......'
#export GMAIL_PASSWORD='.....'
#export AWS_ACCESS_KEY_ID='.......'
#export AWS_SECRET_ACCESS_KEY='.....'
#export AWS_REGION='us-east-1'
#notify = NotifyAwsCost::Notify.new({name: "higeojisan", icon_emoji: ":smile:"})
#notify.send
## To slack
#slack_notify = NotifyAwsCost::Slack.new({warning: 1, critical: 2})
#slack_notify.send

## To mail
mail_notify = NotifyAwsCost::Gmail.new
mail_notify.send
#mail_notify.send
