load './stopwatch.rb'
sw = Stopwatch.new("require");
require 'aws/sts'
require 'aws/dynamo_db'
sw.stop

class Dynamodb
  def self.make_session
    sw = Stopwatch.new("Create AWS session");
    secrets = [ENV['AWS_KEY'], ENV['AWS_SECRET']]
    if(secrets[0]==nil) then
      puts "No heroku configs on this env. I will read local secrets file."
      h = Hash[*File.read('.nao.secrets').split(/[ \n]+/)] 
      secrets = [ h['aws_access_key_id'], h['aws_secret_access_key'] ]
      if(secrets[0]==nil) then
        secrets = [ h['AWS_KEY'], h['AWS_SECRET'] ]
      end
    end
    sts = AWS::STS.new( # sts means security_token_service
      access_key_id: secrets[0],
      secret_access_key: secrets[1]
    )
    @@session = sts.new_session(duration:900)
    AWS.config({dynamo_db_endpoint:"dynamodb.ap-northeast-1.amazonaws.com"})
    sw.stop
  end
  
  def self.connect
    sw = Stopwatch.new("Connect to DynamoDB");
    @@db = AWS::DynamoDB.new(
      access_key_id: @@session.credentials[:access_key_id],
      secret_access_key: @@session.credentials[:secret_access_key],
      session_token: @@session.credentials[:session_token]
    )
    sw.stop()
  end
  
  def self.db
    p @@session.expires_at
    p Time.now.utc
    p @@session.expires_at - Time.now.utc
    exp = @@session.expires_at - Time.now.utc
    if(exp<=30) then 
      puts "AWS Session will expires in #{exp}, so we will remake session now."
      make_session
      connect
    end
    @@db
  end
  
  make_session
  connect
  
end
