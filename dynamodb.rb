load './stopwatch.rb'
sw = Stopwatch.new("require");
require 'aws/sts'
require 'aws/dynamo_db'
sw.stop

class Dynamodb

  def self.read_aws_keys
    puts __method__
    puts "I will try to read AWS keys from environment variables..."
    keys = [ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_KEY']]
    if(keys[0]==nil) then
      puts "No AWS environment variables here. So I will read local secrets file."
      h = Hash[*File.read('.nao.secrets').split(/[ \n]+/)] 
      keys = [ h['AWS_ACCESS_KEY'], h['AWS_SECRET_KEY'] ]
      if(keys[0]==nil) then puts "No secret file here. So I exit.";exit 1;end
    end
    return keys
  end

  def self.make_session
    puts __method__
    sw = Stopwatch.new("Create AWS session");
    keys = read_aws_keys
    sts = AWS::STS.new(access_key_id:keys[0],secret_access_key:keys[1])
    @@session = sts.new_session(duration:900)
    AWS.config({dynamo_db_endpoint:"dynamodb.ap-northeast-1.amazonaws.com"})
    sw.stop
  end
  
  def self.connect
    puts __method__
    sw = Stopwatch.new("Connect to DynamoDB");
    @@db = AWS::DynamoDB.new(
      access_key_id: @@session.credentials[:access_key_id],
      secret_access_key: @@session.credentials[:secret_access_key],
      session_token: @@session.credentials[:session_token]
    )
    sw.stop()
  end
  
  def self.db
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
