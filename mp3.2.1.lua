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

function insert(tablei,tableip,wo,va)  --insert sort
  local pp=1
  if tablei[pp][1] then
    while (pp<tableip) and (tablei[pp][2]>va)  do
      pp=pp+1
    end
    print(pp,"pp")
    for i=tableip-1,pp,-1 do
      tablei[i+1][1]=tablei[i][1]
      tablei[i+1][2]=tablei[i][2]
    end

 end
  tablei[pp][1]=wo
  tablei[pp][2]=va
  for i=1,tableip do
    print(tablei[i][1],tablei[i][2])
  end  
  return  
end    

function train()
  normaltrain={}
	spamtrain={}
  normaltop20={}
  normaltop20point=0
	for k,v in pairs(word[0]) do
       normaltrain[k]=(v+laplacek)/(normalcount+laplacek*normalcount)
       if normaltop20point<20 then 
        normaltop20point=normaltop20point+1
        normaltop20[normaltop20point]={}

       end 
       --insert(normaltop20,normaltop20point,k,normaltrain[k])
  end
  normalnotexist=laplacek/(normalcount+laplacek*normalcount)
  spamtop20={}
  spamtop20point=0
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
       incorrect[t[i][1]]=incorrect[t[i][1]]+1
       confusionmatrix[t[i][1]][tempresult]=confusionmatrix[t[i][1]][tempresult]+1
     end   
    end 	
end	

function odd()
   oddrec={}
   for k,v in pairs(normaltrain) do
     if spamtrain[k] then
       oddrec[k]=math.log(normaltrain[k]/spamtrain[k])
     end  
   end
   gettop20(oddrec)   
end

function gettop20(oddrec)
  top20={}
  top20point=0
  for k,v in pairs(oddrec) do
       if top20point<20 then 
        top20point=top20point+1
        top20[top20point]={}
       end 
       insert(top20,top20point,k,oddrec[k])
  end  
end
function printtrain()
  normaltrain={}
	spamtrain={}
	for k,v in pairs(word[0]) do
       print(k,":",v)
    end
end       

laplacek=1
incorrect={}

confusionmatrix={}
  for i=0,1 do
    confusionmatrix[i]={}
    for j=0,1 do
      confusionmatrix[i][j]=0
    end  
  end 

for i=0,1 do
  incorrect[i]=0
end  
readtrain()
train()
readtest()


print(1-incorrect[0]/normalcount)
print(1-incorrect[1]/spamcount)
catcount={}
catcount[0]=normalcount
catcount[1]=spamcount
  for i=0,1 do
    local tobeprint=""
    for j=0,1 do
      local temp=confusionmatrix[i][j]/catcount[i]
      local ttt=string.format("%.2f", math.floor(temp*10000)/100)
      tobeprint=tobeprint..ttt.."% "
    end
    print(tobeprint)
  end   
odd()
--printtrain()