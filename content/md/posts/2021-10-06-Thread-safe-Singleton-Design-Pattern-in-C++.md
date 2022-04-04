{
 :title "Thread-safe Singleton Design Pattern in C++"
 :layout :post
 :tags  ["c++","design patterns"]
 :toc true}


```C++
class Singleton {
public:
  static std::shared_ptr<Singleton> &GetInstance() {
    static std::shared_ptr<Singleton> instance = nullptr;
    if (!instance) {
      std::lock_guard<std::mutex> lock(Singleton::_mutex);

      if (!instance) {
        instance.reset(new Singleton());
      }

    }
    return instance;
  }
 
  ~Singleton() {}
private:
    Singleton() {
    }
  Singleton(const Singleton &) = delete;
  Singleton(Singleton &&) = delete;
  Singleton &operator=(const Singleton &) = delete;
  Singleton &operator=(Singleton &&) = delete;
  static std::mutex _mutex;
};

std::mutex Singleton::_mutex;
```
