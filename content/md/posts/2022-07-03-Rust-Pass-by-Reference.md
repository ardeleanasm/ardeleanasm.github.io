{
  :title "Rust Pass by Reference"
  :layout :post
  :tags ["rust"]
  :toc true}
  
---

```rust
fn square (x_value: &mut u32) -> () {
    *x_value = 10;
}

fn main() {
    let mut x : u32 = 5;

    square(&mut x);
    println!("x is {0}", x);
    
}
```
