{
 :title "C++ map of member functions"
 :layout :post
 :tags  ["c++"]
 :toc true}


Using look-up tables of member functions is a common use case for implementing and registering callbacks for certain events. 
The syntax for doing this is not quite straightforward.

```C++
#include <iostream>
#include <string>
#include <memory>
#include <functional>
#include <map>
class SomeObj
{
    public:
       void Run(){
           fct_t funct;
           for (auto entry:functionsMap) {
               funct = entry.second;
               funct("some string");
           }
       }
    private:
        void myFunction(const std::string &str)
        {
            std::cout<<str;
        }
        using fct_t = std::function<void(const std::string &)>;
        const std::map<int,fct_t> functionsMap = 
        {
                {1,std::bind(&SomeObj::myFunction, this,
                  std::placeholders::_1)},
        };
};

int main() {
    SomeObj obj;
    obj.Run();

  return 0;
}
```
