function readtrain()
  local f = assert(io.open("train_email.txt", 'r'))
  email={}
  e={}
  word={}
  word[0]={}   --normal word set
  word[1]={}     --spam word set
  normalcount=0
  spamcount=0
  for i=1,700 do
     email[i]=f:read("*line")
     e[i]={}
     e[i][1]=tonumber(string.sub(email[i],1,1))
     if e[i][1]==1 then
     	spamcount=spamcount+1
     else
        normalcount=normalcount+1 	
     end
     email[i]=email[i].." "
     zhizheng=3
     for point=3,string.len(email[i])+1,1 do
     	temp=string.sub(email[i],point,point)
     	if temp==":" then
     	   tempword=string.sub(email[i],zhizheng,point-1)
     	   print(tempword)
     	   zhizheng=point+1
     	end
        
        if temp==" " then
           if not(word[e[i][1]][tempword]) then
           	  word[e[i][1]][tempword]=0
           end	  
           word[e[i][1]][tempword]=word[e[i][1]][tempword]+tonumber(string.sub(email[i],zhizheng,point-1))
           print(word[e[i][1]][tempword])
           zhizheng=point+1
        end
     end


  end
  f:close()
end	

function train()
    normaltrain={}
	spamtrain={}

	for k,v in pairs(word[0]) do
       normaltrain[k]=(v+laplacek)/(normalcount+laplacek*normalcount)
    end
    normalnotexist=laplacek/(normalcount+laplacek*normalcount)
    
	for k,v in pairs(word[1]) do
       spamtrain[k]=(v+laplacek)/(spamcount+laplacek*spamcount)
    end
    spamnotexist=laplacek/(spamcount+laplacek*spamcount)
end  










function printtrain()
    normaltrain={}
	spamtrain={}
	for k,v in pairs(word[0]) do
       print(k,":",v)
    end
end       

readtrain()
train()
printtrain()