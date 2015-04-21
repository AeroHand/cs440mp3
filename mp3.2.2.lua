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
    for i=1,263 do
     tmail[i]=f:read("*line")
     t[i]={}
     t[i][1]=tonumber(string.sub(tmail[i],1,1))  --category
     tmail[i]=tmail[i].." "
     zhizheng=3
     tmailp[i]={}
     for j=0,7 do
       tmailp[i][j]=0 --test point for each class
     end  
     for point=3,string.len(tmail[i])+1,1 do
     	temp=string.sub(tmail[i],point,point)
     	if temp==":" then
     	   tempword=string.sub(tmail[i],zhizheng,point-1)
     	   zhizheng=point+1
     	end
        
        if temp==" " then
           tempv=tonumber(string.sub(tmail[i],zhizheng,point-1))
           for kk=0,7 do
             if train[kk][tempword] then
               tmailp[i][kk]=tmailp[i][kk]+math.log(tempv*train[kk][tempword])
             else
             	 tmailp[i][kk]=tmailp[i][kk]+math.log(tempv*notexist[kk])
             end
           end 

           zhizheng=point+1
        end
     end
     curmax=0
     for j=1,7 do
       if tmailp[i][j]>tmailp[i][curmax] then
         curmax=j
       end
     end  
     print(t[i][1],curmax)
     if not(curmax==t[i][1]) then
       incorrect[t[i][1]]=incorrect[t[i][1]]+1
       confusionmatrix[t[i][1]][curmax]=confusionmatrix[t[i][1]][curmax]+1
     end  
    end

  for i=0,7 do
    local tobeprint=""
    for j=0,7 do
      local temp=confusionmatrix[i][j]/catcount[i]
      local ttt=string.format("%.2f", math.floor(temp*10000)/100)
      tobeprint=tobeprint..ttt.."% "
    end
    print(tobeprint)
  end     	
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

function odd(a,b)
   oddrec={}
   for k,v in pairs(train[a]) do
     if train[b][k] then
       oddrec[k]=math.log(train[a][k]/train[b][k])
     end  
   end
   gettop20(oddrec)   
end

function printtrain()
    normaltrain={}
	spamtrain={}
	for k,v in pairs(word[0]) do
       print(k,":",v)
    end
end       

incorrect={}
confusionmatrix={}
  for i=0,7 do
    confusionmatrix[i]={}
    for j=0,7 do
      confusionmatrix[i][j]=0
    end  
  end 

for i=0,7 do
  incorrect[i]=0
end  
laplacek=1
readtrain()
train()
readtest()



for i=0,7 do
  print(i,":",1-incorrect[i]/catcount[i])
end 
--printtrain()

odd(0,7)