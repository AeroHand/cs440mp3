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
     	   zhizheng=point+1
     	end
        
        if temp==" " then
           if not(word[e[i][1]][tempword]) then
           	  word[e[i][1]][tempword]=0
           end	  
           word[e[i][1]][tempword]=word[e[i][1]][tempword]+tonumber(string.sub(email[i],zhizheng,point-1))
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

function readtest()
    local f = assert(io.open("test_email.txt", 'r'))
    t={}
    tmail={}
    tmailp={}
    for i=1,260 do
     tmail[i]=f:read("*line")
     t[i]={}
     t[i][1]=tonumber(string.sub(tmail[i],1,1))
     tmail[i]=tmail[i].." "
     zhizheng=3
     tmailp[i]={}
     tmailp[i][0]=0
     tmailp[i][1]=0
     for point=3,string.len(tmail[i])+1,1 do
     	temp=string.sub(tmail[i],point,point)
     	if temp==":" then
     	   tempword=string.sub(tmail[i],zhizheng,point-1)
     	   --print(tempword)
     	   zhizheng=point+1
     	end
        
        if temp==" " then
           tempv=tonumber(string.sub(tmail[i],zhizheng,point-1))

           if normaltrain[tempword] then
             tmailp[i][0]=tmailp[i][0]+math.log(tempv*normaltrain[tempword])
           else
           	 tmailp[i][0]=tmailp[i][0]+math.log(tempv*normalnotexist)
           end

           if spamtrain[tempword] then
             tmailp[i][1]=tmailp[i][1]+math.log(tempv*spamtrain[tempword])
           else
           	 tmailp[i][1]=tmailp[i][1]+math.log(tempv*spamnotexist)
           end

           zhizheng=point+1
        end
     end

     if tmailp[i][1]>tmailp[i][0] then
       tempresult=1
     	 print(i,"spam",t[i][1])
     else	
        tempresult=0
        print(i,"normal",t[i][1])
     end

     if not(tempresult==t[i][1]) then
       incorrect=incorrect+1
     end   
    end 	
end	

function test()
    --normal value

end	

function printtrain()
  normaltrain={}
	spamtrain={}
	for k,v in pairs(word[0]) do
       print(k,":",v)
    end
end       

laplacek=1
incorrect=0
readtrain()
train()
readtest()
print(incorrect/260)
--printtrain()