ruleset sensor_profile {
  
  meta {
    use module twilio
        with sid = meta:rulesetConfig{"sid"}
        and auth_token =meta:rulesetConfig{"auth_token"}

    provides get_threshold, get_notification_dest, send_message
    shares get_sensor_profile
  }

  global {

    get_threshold = function() {
      ent:threshold.defaultsTo(74)
    }

    get_notification_dest = function() {
      ent:notification_dest.defaultsTo("+17125773253")
    }

    get_sensor_profile = function() {
      {"name": ent:name.defaultsTo(""), "location": ent:location.defaultsTo(""), "threshold": get_threshold(), "notification_dest": get_notification_dest()}
    }

    send_message = defaction(msg) {
      twilio:send_message(msg, get_notification_dest())
    }
  }
  
  rule sensor_profile {
    select when sensor profile_updated
    
    always {
      ent:name := event:attrs{"name"}
      ent:location := event:attrs{"location"}
      ent:threshold := event:attrs{"threshold"}
      ent:notification_dest := event:attrs{"notification_dest"}
    }
  }
}