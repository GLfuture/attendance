# API

## return code

//login

code: 0 //Login success

code: 1 //password error

code: 2 //no user(maybe need to register?)

code: 3 //captcha  error(expire or error)

//register

code: 4 //register success

code: 5 //has repeated username

code: 6 //register failed

code: 7 //captcha  error(expire or error)

//logout

code: 8 //logout success

code: 9 //logout fail



//others

code: 10 //has no token in head

code: 11 //token expire

code: 12 //json has errors

code: 13 //json doesn't has necessary member

code: 14 //method operates successfully

code: 15 //method operates fail

code: 16 //method error

code: 17 //privilidge error

code: 18 //clok reaptedly(already clocked)

code: 19 //didn't clock in(not ready to clock)

code: 20 //url error

code: 21 //email send successfully

code: 22 //email send error

code: 23 //some  unkown error

## smtp

(支持多邮件发送)

url: /api/smtp

//method : 0 (发送验证码)

```
need:
{
	"method": 0  //send captcha
	"email": ""
}
```

```
return:
{
	"code":
}
```

//method : 1 (发送邮件)

only manager can send

```
need:
	head:token 
{
	"method": 1,
	"emails": ["","",""],
	"subject":	"",//主题
	"content_type":	"", //such as text/html
	"charset":"",		//such as utf8mb4
	"content": 	""
}
```

```
return :
{
	"code": 
}
```



## login

url:/api/login

(role: 0 //manager     1 //simple user)

manager can only use username and password to login

```json
need: { 
    	"method":0,  
    	"role":1, 
    	"username":"",
    	"password":"" 
	}
```

```json
return: 
head: Token //http header中带有身份信息的token字段
{ 
	"code": 
}
```

add:

邮箱登录:

simple user can use this method

```
need: 
{
	"method" : 1,
	"email": ""
	"captcha": ""
}
```

```
return:
{
	"code":
}
```



## register

url:/api/register

"only simple user can access"

doesn't  allow  repeated  username,email,telphone 

```json
need: 
{ 
    "username": varchar(15) ,
    "password": varchar(20),
    "email": varchar(20),
    "phone": varchar(20),
    "address": varchar(20),
    "sex": int ,//0 女 1 男
    "captcha": "",
}
```

```json
return : { "code": code }
```

## change card's data(add/delete/update)

url:/api/card

(method: 0 //new card need card's name(only manager can access)

method: 1 //delete need uid and cid(simple user del his card record  ,   manager del one card (this card will be destoryed)) 

method: 2 //update need uid and cid and num)

```json
need:
{ 
    	"method" :0,
       	"cname"  :"",
    	"description":"",//不超过80个字节
}
```

```json
return: { "code": }
```

or

(delete card(simple user delete his card		manager delete this card's type))

```json
need: 
{	
    	"method":1,
	"cid": int 
}
```

```json
return : { "code": }
```

or

(change user's card's num)

 simple user:

 ```json
need:
{ 
    	"method":2, 
 	"cid": int,
    	"num": int, //+为加,-为减 
}
 ```

```json
return: { "code": }
```

manager:

```json
need:
{ 
    	"method":2 ,
 	"uid": int,
    	"cid": int,
    	"num": int,
    	"description": "" //不超过80个字节，如果没有该字段或者为空就不修改卡片描述
}
```

```json
return: { "code": }
```



## change user's data 

url /api/user

(only simple user can access)

```json
need: { //需要改哪些字段传哪些字段，也可以全传 
    	"username": varchar(15) ,
    	"password": varchar(20),
    	"email": varchar(20),
    	"telphone": varchar(20),
    	"address": varchar(20),
    	"sex": int //0 女 1 男
	}
```

```
return: { "code": }
```



## change time‘s data

url /api/time

simple user:

(打卡开始)

```
need: { "method":1 }
```

```json
return: { "code": }
```

(打卡结束)

```
need: { "method":0 }
```

```json
return: 
{ 
    	"time":  int64_t,//时间戳 
 	"code":
}
```

修改需要打卡时间:

```json
need:{
    "uid":		//可选字段,存在即修改该用户，不存在修改自己
    "method":2,
    "time":		//时间戳 +代表增加需要打卡时间，-代表减少需要打卡时间,秒级
}
```

```
return:{
	"code":
}
```

manager:

(method: 0 //清空所有人打卡时间 )

```
need:
{
	"method":
}
```

```json
return: 
{ 
    "code": 
}
```

(method: 1//设置打卡时间)

```
need:
{
	"method":
	"time":		int64_t(秒级时间戳)
}
```

```
return:
{
	"code":
}
```

## get user's cards

url /api/data/card/concrete

(attention: get your cards)

simple user:

```json
return : 
{ 
    "cid1":
    { 
        "cardname": concrete_cardname,
        "num": concrete_num(int)  
    }, 
    "cid2":
    { 
        "cardname": concrete_cardname,
        "num": concrete_num(int)  
    } 
    ... 
}
no card return "null"
other error situations return code
```

manager: 

(get all users' cards)

```json
return :
{ 
    "uid1": 
    {
        "username": 
        "cid1":	{ 
        			"cardname" : concrete_cardname,
        			"num" : concrete_num(int) 
		},
     	"cid2"：{ 
            		"cardname": concrete_cardname
            		"num" : concrete_num(int)  
		}
		...
    },
	"uid2": 
    {
        "username": 
        "cid1":	{ 
        			"cardname" : concrete_cardname,
        			"num" : concrete_num(int)
		},
     	"cid2"：{ 
            		"cardname": concrete_cardname
            		"num" : concrete_num(int)  
		}
		...
    },
}
no card return "null"
other error situations return code
```



## get all cards' data

url:/api/data/card?page=0

(both simple user and manager can access)

(attention:  cid1 representes concrete cid)

```json
return: 
{ 
    "cid1": 
 	{ 
        	"cardname": concrete_cardname,
        	"description":
    	} 
    "cid2": 
    	{ 
        	"cardname": concrete_cardname,
    		"description":
    	} 
    ... 
}
```



## get user's data

manager:/api/data/user?page=0

(attention: get all users' data)

(manager can access)   

```json
return: { 
    		"concert_uid":
			{ 
     				"username":concert_username,
     				"email": concert_eamil,
     				"telphone": concert_telphone,
     				"address": concert_address,
     				"sex": //0 女 1 男 
    			}  
            ... 
         }
```



user:api/data/user

(expect sex is int ,others are string)

(attention: get your data)

(simple user can access)

```json
return: 
{ 
   "concrete_uid": 
   { 
     "username":concert_username,
     "email": concert_eamil,
     "telphone": concert_telphone,
     "address": concert_address,
     "sex": //0 女 1 男 
    } 
}
```



## get time's data(get all users' time data)

api/data/time 

(both simple user and manager can access)

```json
return:
{ 
    "uid1":
	{
        	"username": "",
        	"sex": int ,
        	"total_time":int64_t ,  //秒级
        	"need_time":int64_t
    	}
}
```



attention: username+data 代表真实用户名 username不加data 代表“username”这个key
