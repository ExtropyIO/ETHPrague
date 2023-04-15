# Sudoku in Risc Zero

There are 3 components 
- source code for guest
- code that builds the guest code
- source code for host

## Typical Risc Zero project layout

project_name
├── Cargo.toml
├── host
│   ├── Cargo.toml
│   └── src
│       └── main.rs                        <-- Host code goes here
└── methods
    ├── Cargo.toml
    ├── build.rs                           <-- Build (embed) code goes here
    ├── guest
    │   ├── Cargo.toml
    │   └── src
    │       └── bin
    │           └── method_name.rs         <-- Guest code goes here
    └── src
        └── lib.rs                         <-- Build (include) code goes here
