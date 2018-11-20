require 'notify_aws_cost'

#export SLACK_WEBHOOK_URL='......'
#export AWS_ACCESS_KEY_ID='.......'
#export AWS_SECRET_ACCESS_KEY='.....'
#export AWS_REGION='us-east-1'
#notify = NotifyAwsCost::Notify.new({name: "higeojisan", icon_emoji: ":smile:"})
#notify.send
notify = NotifyAwsCost::Notify.new({warning: 2.2222})
notify.send
