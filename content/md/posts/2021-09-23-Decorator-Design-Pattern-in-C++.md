{
 :title "Decorator Design Pattern in C++"
 :layout :post
 :tags  ["c++","design patterns"]
 :toc true}



```C++
#include <iostream>
#include <string>
#include <memory>
/**
 * The base Component interface 
 */
class Component {
 public:
  Component(){std::cout<<"[Constructor] Component\n";}
  virtual ~Component(){std::cout<<"[Destructor] Component\n";}
  virtual void Operation() = 0;
};
/**
 * Concrete Components 
 */
class ConcreteComponent : public Component {
 public:
  ConcreteComponent(){std::cout<<"[Constructor] ConcreteComponent\n";}
  ~ConcreteComponent(){std::cout<<"[Destructor] ConcreteComponent\n";}
  void Operation() override {
    std::cout<<"ConcreteComponent";
  }
};

class Decorator : public Component {

 protected:
  std::unique_ptr<Component> component_;

 public:
  
  Decorator( std::unique_ptr<Component> component)  {
      component_=std::move(component);
      std::cout<<"[Constructor] Decorator\n";
  }
  ~Decorator(){std::cout<<"[Destructor] Decorator\n";}
  
 
  void Operation()  override {
    this->component_->Operation();
  }
};

class ConcreteDecorator : public Decorator {
  
 public:
  
  ConcreteDecorator( std::unique_ptr<Component> component) : Decorator(std::move(component)) {
      std::cout<<"[Constructor] ConcreteDecorator\n";
  }
  ~ConcreteDecorator() {std::cout<<"[Destructor] ConcreteDecoratorA\n";}
  void Operation()  override {
    std::cout<< "ConcreteDecorator("; Decorator::Operation(); std::cout<<")";
  }
};


int main() {
 
  std::unique_ptr<Component> simple=std::make_unique<ConcreteComponent>();
  std::cout << "Client: I've got a simple component:\n";
  simple->Operation();
  std::cout << "\n\n";

   std::unique_ptr<Component> decorator = std::make_unique<ConcreteDecorator>(std::move(simple));
   std::cout << "Client: Now I've got a decorated component:\n";
   decorator->Operation();
   std::cout << "\n";

   

  return 0;
}
```
