{
  :title "Conway's game of life implementation in Rust using ChatGPT"
  :layout :post
  :tags ["rust"]
  :toc true}
 
 ---

```rust
use std::io;

const WIDTH: usize = 20;
const HEIGHT: usize = 20;

struct Grid {
    cells: [[u8; WIDTH]; HEIGHT],
}

impl Grid {
    fn new() -> Grid {
        Grid {
            cells: [[0; WIDTH]; HEIGHT],
        }
    }

    fn get_neighbors(&self, x: usize, y: usize) -> u8 {
        let mut count = 0;
        for i in x.saturating_sub(1)..=x+1 {
            for j in y.saturating_sub(1)..=y+1 {
                if i == x && j == y {
                    continue;
                }
                if i < WIDTH && j < HEIGHT && self.cells[i][j] == 1 {
                    count += 1;
                }
            }
        }
        count
    }

    fn next_gen(&self) -> Grid {
        let mut next = Grid::new();
        for i in 0..WIDTH {
            for j in 0..HEIGHT {
                let neighbors = self.get_neighbors(i, j);
                if self.cells[i][j] == 1 && (neighbors == 2 || neighbors == 3) {
                    next.cells[i][j] = 1;
                } else if self.cells[i][j] == 0 && neighbors == 3 {
                    next.cells[i][j] = 1;
                }
            }
        }
        next
    }

    fn display(&self) {
        for i in 0..HEIGHT {
            for j in 0..WIDTH {
                if self.cells[j][i] == 1 {
                    print!("*");
                } else {
                    print!(" ");
                }
            }
            println!("");
        }
    }
}

fn main() {
    let mut grid = Grid::new();

    // Initialize the grid with some cells
    grid.cells[10][10] = 1;
    grid.cells[10][11] = 1;
    grid.cells[10][12] = 1;

    loop {
        grid.display();
        grid = grid.next_gen();
        println!("");
        println!("");

        let mut buffer = String::new();
        io::stdin().read_line(&mut buffer).unwrap();
    }
}

```
