---
layout: blog/post
title: "Thread-safe Singleton Design Pattern in C++"
description: "Thread-safe Singleton Design Pattern in C++"
category: c++
tags: c++, Design Patterns
---

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
