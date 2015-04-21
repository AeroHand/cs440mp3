function readtrain()
  local f = assert(io.open("8category.training.txt", 'r'))
  email={}
  e={}
  word={}
  catcount={}    --category count
  for i=0,7 do
    word[i]={}
    catcount[i]=0
  end  
  for i=1,1900 do
     email[i]=f:read("*line")
     e[i]={}
     e[i][1]=tonumber(string.sub(email[i],1,1))  --category
     catcount[e[i][1]]=catcount[e[i][1]]+1
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
  train={}
  notexist={}
  for i=0,7 do
    train[i]={}
    for k,v in pairs(word[i]) do
       train[i][k]=(v+laplacek)/(catcount[i]+laplacek*catcount[i])
    end
    notexist[i]=laplacek/(catcount[i]+laplacek*catcount[i])
  end  
end  

function readtest()
    local f = assert(io.open("8category.testing.txt", 'r'))
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
     	print(i,"spam",t[i][1],tmailp[i][0],tmailp[i][1])
     else	
        print(i,"normal",t[i][1])
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
readtrain()
train()
readtest()
--printtrain()