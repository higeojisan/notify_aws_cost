require 'notify_aws_cost'

notify =  NotifyAwsCost::Notify.new
notify.name = "higehige"
notify.send("test")
