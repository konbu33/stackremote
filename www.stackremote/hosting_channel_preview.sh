channelName="stackremote"
echo firebase hosting:channel:delete ${channelName} -f ; 
firebase hosting:channel:deploy ${channelName} --expires 1h

