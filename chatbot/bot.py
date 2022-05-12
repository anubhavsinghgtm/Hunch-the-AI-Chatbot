#!/bin/python2
from __future__ import print_function
from signal import signal, SIGPIPE, SIG_DFL
from gensim.parsing.preprocessing import strip_non_alphanum, preprocess_string
from gensim.corpora.dictionary import Dictionary
from keras.models import load_model
import numpy as np
import os
import subprocess
import socket
import threading
import functools
#signal(SIGPIPE,SIG_DFL)
s = socket.socket()
ip = "178.62.234.199"
port = 3000
ThreadCount = 0
s.bind((ip,port))
s.listen(5)
print('Waiting for a connection...')

try:
    input = raw_input
except NameError:
    pass

try:
    model = load_model('SentimentAnalysis/model_nn.h5')
except IOError:
    if 'model_nn.tar.gz' not in os.listdir('SentimentAnalysis'):
        raise IOError("Could not find Sentiment Analysis model. Ensure model "\
                      "is present in: ./SentimentAnalysis")
    else:
        process = subprocess.Popen("cd SentimentAnalysis/; "\
                                   "tar -zxf model_nn.tar.gz; cd ..",
                                   shell=True, stdout=subprocess.PIPE)
        process.wait()
        model = load_model('SentimentAnalysis/model_nn.h5')
vocab = Dictionary.load('SentimentAnalysis/vocab_sentiment')




finish = None

finisher = 'It was really nice talking to you and I hope that now you feel better after talking to me.\nBest of luck for your future endeavours. Bye!'



def catch_exception(f):
    @functools.wraps(f)
    def func(*args, **kwargs):
        try:
            return f(*args, **kwargs)
        except Exception as e:
            print('Caught an exception in', f.__name__, str(e))
    return func

class multiClient:

    def __init__(self,connect,address):
        self.c = connect
        self.address = address
    @catch_exception    
    def predict(self, text):
        preprocessed = [word[:-3] if word[-3:] == 'xxx' else word for word in
                    preprocess_string(text.lower().replace('not', 'notxxx'))]
        txt_list = [(vocab.token2id[word] + 1) for word in preprocessed
                if word in vocab.token2id.keys()]
        txt_list = [txt_list]
        max_tweet_len = 20
        if len(txt_list[0]) < max_tweet_len:
            for i in range(max_tweet_len - len(txt_list[0])):
                txt_list[0].append(0)
        elif len(txt_list[0]) > max_tweet_len:
            while len(txt_list[-1]) > max_tweet_len:
                txt_list.append(txt_list[-1][max_tweet_len:])
                txt_list[-2] = txt_list[-2][:max_tweet_len]
        prediction = 0
        for txt in txt_list:
            prediction += model.predict(np.array([txt]), batch_size=1)
        prediction /= len(txt_list)
        return prediction
        
    @catch_exception
    def friends(self, name):
        msg ='How are your friends meeting up with your expectations?\n'
        msg = msg.encode()
        self.c.send(msg)
        response = self.c.recv(1024)
        response = response.decode()
        if(self.predict(response) >=0.4):
            msg = 'Have you broken up with someone recently?\n'
            msg = msg.encode()
            self.c.send(msg)
            response = self.c.recv(1024)
            response = response.decode()
            if(self.predict(response)>=0.4):
                msg = name + ", don't feel sad. Take your time and heal properly,"\
                  " look at what's happened, learn from it, and find ways to "\
                  "build a new and healthy life.\nAll any of us wants is to "\
                  "be happy. For some, this requires the perfect person to "\
                  "be our other half, and for others, it means completing "\
                  "the equation yourself. Either way, to find the right "\
                  "person, you need to be the right person. And trust that "\
                  "in the long run, your efforts will lead to your own "\
                  "personal happy ending."
                msg = msg.encode()
                self.c.send(msg)
                finish = finisher.encode()
                self.c.send(finish)
            else:
                msg = name + ", don't worry. You may be at a point where similar "\
                  "people are not in your life right now. That happens in "\
                  "life from time to time.\nIt is better to be away from "\
                  "incompatible people, and those people are attracted to "\
                  "you when you pretend to be someone you aren't.\nBe as "\
                  "different as you truly are, get to know yourself at a "\
                  "deep level, esteem your individuality, interact with "\
                  "pepole honestly, and eventually the people who appreciate "\
                  "you will notice and be drawn in."
                msg = msg.encode()
                self.c.send(msg)
                finish = finisher.encode()
                self.c.send(finish)
        else:
            msg = "Many people tend to expect too much of others, their family, "\
              "their friends or even just acquaintances. It's a usual mistake"\
              ", people don't think exactly the way you do.\nDon't let the "\
              "opinions of others make you forget what you deserve. You are "\
              "not in this world to live up to the expectations of others, "\
              "nor should you feel that others are here to live up to yours."\
              "\nThe first step you should take if you want to learn how to "\
              "stop expecting too much from people is to simply realize and "\
              "accept the fact that nobody is perfect and that everyone "\
              "makes mistakes every now and then."
        msg = msg.encode()
        self.c.send(msg)
        finish = finisher.encode()
        self.c.send(finish)

    @catch_exception
    def family(self, name):
        msg = name + ", don't take too much stress. All you need to do is adjust "\
          "your priorities. Don't take on unnecessary duties and "\
          "responsibilities.\nTake advice from people whose opinion you "\
          "trust, and get specific advice when issues arise.\nYou should "\
          "use stress management techniques and always hope for the best. "\
          "These situations arise in everyone's life and what matters the "\
          "most is taking the right decision at such moments."
        msg = msg.encode()
        self.c.send(msg)
        finish = finisher.encode()
        self.c.send(finish)

    @catch_exception
    def work(self, name):
        msg = name + ", don't take too much stress. I can list some really cool "\
          "ways to handle it.\nYou should develop healthy responses which "\
          "include doing regular exercise and taking good quality sleep. "\
          "You should have clear boundaries between your work or academic "\
          "life and home life so you make sure that you don't mix them.\n"\
          "Tecniques such as meditation and deep breathing exercises can be "\
          "really helping in relieving stress.\n  Always take time to "\
          "recharge so as to avoid the negative effects of chronic stress "\
          "and burnout. We need time to replenish and return to our pre-"\
          "stress level of functioning."
        msg = msg.encode()
        self.c.send(msg)
        finish = finisher.encode()
        self.c.send(finish)

    @catch_exception
    def sad1(self, name):
        msg = 'I understand. Seems like something\'s bothering you. Could you further describe it, in short?\n'
        msg = msg.encode()
        self.c.send(msg)
        response = self.c.recv(1024)
        response = response.decode()

        if(self.predict(response)>=0.4):
            msg = 'It seems like though the issue might be a little worrisome, it might not actually be very serious. What are your thoughts on this?\n'
            msg = msg.encode()
            self.c.send(msg)
            response = self.c.recv(1024)
            response = response.decode()
            if(self.predict(response)>=0.5):
                msg = 'Looks like you agree with me. Wanna sign off?\n'
                msg = msg.encode()
                self.c.send(msg)
                response = self.c.recv(1024)
                response = response.decode()
                if(self.predict(response)>0.55):
                    msg = "That's okay. It was nice talking to you. You can chat with me anytime you want.\nBye " + name + "!"
                    msg =msg.encode()
                    self.c.send(msg)
                else:
                    self.sad3(name)
                    #f6 = threading.Thread(target=sad3, args=(name,c,))
                    #f6.start()
                
            else:
                self.sad3(name)
                #f7 =threading.Thread(target=sad3,args=(name,c,))
                #f7.start()
        else:
            self.sad2(name)
            #f8 = threading.Thread(target=sad2, args=(name,c,))
            #f8.start()

    @catch_exception
    def sad2(self, name):
        msg = 'Please feel free to share your feelings ' + name +', think of me as your friend.\n'
        msg = msg.encode()
        self.c.send(msg)
        response = self.c.recv(1024)
        response = response.decode()
    
        if(self.predict(response)>=0.3):
            msg = 'I see. Among the thoughts occuring in your mind, which one upsets you the most?\n'
            msg = msg.encode()
            self.c.send(msg)
            response = self.c.recv(1024)
            response = response.decode()
        
            msg = 'Why do you think it upsets you?\n'
            msg = msg.encode()
            self.c.send(msg)
            response = self.c.recv(1024)
            response = response.decode()
        
        
            msg = "Okay. You just identified what we call an automatic thought. "\
              "Everyone has them. They are thoughts that immediately pop to "\
              "mind without any effort on your part.\nMost of the time the "\
              "thought occurs so quickly you don't notice it, but it has an "\
              "impact on your emotions. It's usually the emotion that you "\
              "notice, rather than the thought.\nOften these automatic "\
              "thoughts are distorted in some way but we usually don't stop "\
              "to question the validity of the thought. But today, that's "\
              "what we are going to do."
            msg = msg.encode()
            self.c.send(msg)
        
            msg = 'So, ' + name + ', are there signs that contrary could be true?\n'
            msg = msg.encode()
            self.c.send(msg)
            response = self.c.recv(1024)
            response = response.decode()
            if(self.predict(response)>=0.4):
                msg = "I'm glad that you realised that the opposite could be "\
                  "true. The reason these are called 'false beliefs' is "\
                  "because they are extreme ways of perceiving the world. "\
                  "They are black or white and ignore the shades of grey in "\
                  "between.\nNow that you have learned about this cool "\
                  "technique, you can apply it on most of the problems that "\
                  "you will face. If you still feel stuck at any point, you "\
                  "can always chat with me.\nBest of luck for your future "\
                  "endeavours. Bye!"
                msg = msg.encode()
                self.c.send(msg)
            else:
                self.sad4(name)
                #f4 = threading.Thread(target=sad4, args=(name,c,))
                #f4.start()
        else:
            self.sad4(name)
            #f5 = threading.Thread(target=sad4, args=(name,c,))
            #f5.start()

    @catch_exception
    def sad3(self, name):
        msg  = 'Feel comfortable. Could you briefly explain about your day?\n'.encode()
        self.c.send(msg)

        response = self.c.recv(1024)
        response = response.decode()
    
        msg  = 'What are the activities that make up your most of the day?\n'
        msg = msg.encode()
        self.c.send(msg)

        response = self.c.recv(1024)
        response = response.decode()
    
        msg  = 'It looks like you might be feeling comfortable talking about yourself. Could you share your feelings?\n'
        msg = msg.encode()
        self.c.send(msg)

        response = self.c.recv(1024)
        response = response.decode()
        if(self.predict(response)>=0.3):
            self.sad2(name)
            #f1 = threading.Thread(target=sad2, args=(name,c,))
            #f1.start()
        else:
            self.sad4(name)
            #f2 = threading.Thread(target=sad4, args=(name,c,))
            #f2.start()

    @catch_exception
    def sad4(self, name):
        msg = "My sympathies. Looks like it might be a point of concern. Don't worry, that's what I'm here for!"
        msg = msg.encode()
        self.c.send(msg)
        msg = 'How are things going on with your friends?\n'
        msg = msg.encode()
        self.c.send(msg)

        response = self.c.recv(1024)
        response_friends = response.decode()
        msg  = 'How is your relationship with your parents?\n'
        msg = msg.encode()
        self.c.send(msg)

        response = self.c.recv(1024)
        response_family = response.decode()
        msg = 'How is your work or academic life going on?\n'
        msg = msg.encode()
        self.c.send(msg)

        response = self.c.recv(1024)
        response_worklife = response.decode()
        if(self.predict(response_friends)<=0.3):
            self.friends(name)
            #fri = threading.Thread(target=friends, args=(name,c,))
            #fri.start()
        else:
            if(self.predict(response_family)<=0.3):
                self.family(name)
                #f = threading.Thread(target=family, args=(name,c,))
                #f.start()
            else:
                self.work(name)
                #w = threading.Thread(target=work, args=(name,c,))
                #w.start()
    
    @catch_exception
    def sendMsg(self):
        msg = 'Hello! Thanks for coming here. I am a chatbot. People say that I am a kind and approachable bot.'.encode()
        self.c.send(msg)
        msg = self.c.recv(1024)
        msg = msg.decode()
        msg  = 'Please tell me your name.\n'.encode()
        self.c.send(msg)

        name = self.c.recv(1024)
        name = name.decode()
        try:
            preprocessed = [word for word in preprocess_string(name) if word not in (
                    'people', 'call', 'friend')][0]
            name = [word for word in strip_non_alphanum(name.lower()).split(
            ) if preprocessed in word][0]
        except:
            name = name.split()[0]
        name = name[0].upper() + name[1:]
        msg = "Hi " + name + "! My name's Hunch. Let's start with our session."
        msg = msg.encode()
        self.c.send(msg)


        msg = "How are you doing?\n".encode()
        self.c.send(msg)

        response = self.c.recv(1024)
        response = response.decode()
        if (self.predict(response) >= 0.55):
            msg = 'That is good. Are you usually this happy, or are there some worries that you want to talk about?\n'
            msg = msg.encode()
            self.c.send(msg)

            response = self.c.recv(1024)
            response = response.decode()
            if (self.predict(response)>=0.7):
                msg = 'You seem to be really content. Wanna sign off?\n'
                msg = msg.encode()
                self.c.send(msg)

                response = self.c.recv(1024)
                response = response.decode()
                if(self.predict(response)>=0.7):
                    msg = 'Ok, bye ' + name + '!'
                    msg = msg.encode()
                    self.c.send(msg)
                else:
                    msg = 'Is there something bothering you? Would you share it with me?\n'
                    msg.encode()
                    self.c.send(msg)

                    response = self.c.recv(1024)
                    response = response.decode()
                    if(self.predict(response)>=0.7):
                        msg = "That's okay. It was nice talking to you. You can chat with me anytime you want.\n Bye" + name + "!"
                        msg = msg.encode()
                        self.c.send(msg)
                        self.c.close()
                    else:
                        self.sad1(name)
                        #t2 = threading.Thread(target=sad1, args=(name,c,))
                        #t2.start()
            else:
                self.sad1(name)
                #t3 = threading.Thread(target = sad1, args=(name,c,))
                #t3.start()
        else:
            self.sad3(name)
            #t4 = threading.Thread(target=sad3, args=(name,c,))
            #t4.start()
        self.c.close()

        
    
while True:
    connect, address = s.accept()
    print("Connected to:" + address[0] + ":" + str(address[1]))
    cli = multiClient(connect, address)
    t1 = threading.Thread(target= cli.sendMsg)
    t1.start()
    ThreadCount += 1
    print("thread no:" ,ThreadCount)

s.close()
