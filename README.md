# Snake Game (Assembly Language)

A **classic Snake game** implemented in **Assembly Language** using BIOS interrupts for graphics and keyboard input.

## 📌 Features
- Classic Snake gameplay
- Simple graphics using ASCII characters
- Real-time keyboard input handling
- Score tracking
- Game-over detection

## 🛠️ Technologies Used
- **Assembly Language (x86)**
- **BIOS interrupts for input/output**
- **DOSBox** (for execution on modern systems)

## 🚀 Installation & Setup
### Prerequisites
Ensure you have the following installed:
- DOSBox or an x86 emulator
- NASM (Netwide Assembler) or TASM

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/SnakeGame-Assembly.git
   cd SnakeGame-Assembly
   ```
2. Assemble the code:
   ```bash
   nasm -f bin snake.asm -o snake.com
   ```
3. Run the game using DOSBox:
   ```bash
   dosbox
   mount c: .
   c:
   snake.com
   ```

## 🎮 How to Play
- Use **arrow keys** to control the snake.
- Eat food to grow longer.
- Avoid colliding with walls or yourself.
- The game ends when the snake crashes.

## 📝 License
This project is licensed under the **MIT License**.

## 🤝 Contributing
Feel free to submit pull requests or report issues!

## 📬 Contact
For any questions, reach out via GitHub Issues or email.

Enjoy coding in Assembly! 🚀

