# NotifyAwsCost
当月の前日までのAWS利用料金をslackに通知します

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'notify_aws_cost', git: 'https://github.com/higeojisan/notify_aws_cost.git'
```

And then execute:

    $ bundle

## Usage

### Prerequisite
```
export SLACK_WEBHOOK_URL='......'
export AWS_ACCESS_KEY_ID='.......'
export AWS_SECRET_ACCESS_KEY='.....'
export AWS_REGION='us-east-1'
```

### Sample(1)
```ruby
require 'notify_aws_cost'

notify = NotifyAwsCost::Notify.new
notify.send
```

![](https://github.com/higeojisan/notify_aws_cost/tree/master/sample_images/sample_1.png)
