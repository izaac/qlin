'''
Created on May 19, 2011

@author: chunwei
'''
#需要添加进动态内存管理
#但似乎动态管理不可能--词库中char长度不一
#需要提前知道词库大小(可以保存到sqlite)
#本文件包含两个库 建立词库  及新建词库

# *******相关函数可以考虑写为   inline   提供必要接口

cdef class Create_Thesaurus:
    '''
    新建词库
    '''
    #此处字符串传入方式需要确定

    cdef: 
        char* ph        #词库的存储目录
        #char* widph     #范围的存储目录 
        object li


    def __cinit__(self,char* ph):
        '''
        传入文件目录
        '''
        print 'begin init'

        self.ph=ph
        print 'get ph is',self.ph
        #空词库list
        self.li=[]

    def find(self,word):
        '''
        在list中查找word
        如果查找到 返回True
        如果没有找到 返回False
        '''
        print 'begin find()'

        #定义变量
        cdef:
            int l
            int first
            int end
            int mid
            int num

        #初始值
        l=len(self.li)
        first=0
        end=l-1
        mid=0
        num=hash(word)

        print 'the hash of',word,"is",
        print num
        print 'the len of self.li is',l
        
        if l==0:
            print 'the list is empty'
            self.li.insert(0,word)
            return False
        
        while first<end:
            mid=(first+end)/2

            if num>hash(self.li[mid]):
                first=mid+1

            elif num<hash(self.li[mid]):
                end=mid-1

            else:
               first=mid
               end=mid

               while hash(self.li[first])==num and first>=0:
                   
                    if self.li[first]==word:
                        return True
                    first-=1

               while hash(self.li[end])==num and end<l:
                   
                    if self.li[end]==word:
                        return True 
                    end=end+1

               self.li.insert(mid+1,word)

               return False
            
        if first==end:
            if hash(self.li[first])>num:
                self.li.insert(first,word)+' '
                return False

            elif hash(self.li[first])<num:
                self.li.insert(first+1,word)
                return False

            else:
                
                if self.li[first]==word:
                    return True

                else:
                    self.li.insert(first+1,word)
                    return False

        elif first>end:
            self.li.insert(first,word)
            return False

        else:
            return True

    def show(self):
        '''
        展示词库
        '''
        for i in self.li:
            print i

    cdef char *get_str(self):
        '''
        保存时使用字符串直接保存
        将self.li转化为str进行保存
        '''
        print 'begin get_str()'
        
        cdef char *str

        strr=''
        for i in self.li:
            strr+=i+' '

        return strr

    def save(self):
        '''
        保存词库
        格式： 直接采用的字符串空格
        '''
        print 'begin to save all the words!'
        print 'the file ph is',self.ph
        print 'str is',self.get_str()

        f=open(self.ph,'w')
        f.write( self.get_str() )
        f.close()

    def save_wide(self,char *widph):
        '''
        保存有关  词库中hahs之范围的两
        格式大概为  min max 
        '''
        print 'begin to save width'
        space=' '
        strr=str(hash( self.li[0] ) ) + space + str(hash( self.li[-1] ) )
        print 'the width is',strr
        f=open(widph,'w')
        f.write(strr)
        f.close()
        

