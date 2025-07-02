# Microprocessors and Embedded Systems - Project 1

This repository contains three embedded system projects implemented using PIC16F877A microcontroller assembly language. Each project demonstrates different aspects of microcontroller programming including interrupt handling, timing control, and analog-to-digital conversion.

## 📋 Project Overview

This project consists of three distinct applications:

1. **Question 1 (Q1)**: Digital Counter with LCD Display and External Interrupt
2. **Question 2 (Q2)**: Traffic Light Control System
3. **Question 3 (Q3)**: ADC-based Analog Signal Processing with 7-Segment Display

## 🔧 Hardware Requirements

- **Microcontroller**: PIC16F877A
- **Development Environment**: MPLAB IDE with PIC assembler
- **Simulation Software**: Proteus Design Suite
- **Components**:
  - 16x2 LCD Display (for Q1)
  - LEDs (Red, Yellow, Green for Q2)
  - 7-Segment Displays (for Q3)
  - Push button for external interrupt (Q1)
  - Analog input source (Q3)
  - Resistors and connecting wires

## 📁 Project Structure

```
Project1/
├── Q1/                    # Counter with LCD and Interrupt
│   ├── ragoQ1.asm        # Assembly source code
│   ├── question1.pdsprj  # Proteus simulation file
│   └── ragoQ1.*          # Compiled files
├── Q2/                    # Traffic Light System
│   ├── ragoQ2.asm        # Assembly source code
│   ├── question2.pdsprj  # Proteus simulation file
│   └── ragoQ2.*          # Compiled files
├── Q3/                    # ADC with 7-Segment Display
│   ├── ragoQ3.asm        # Assembly source code
│   ├── question3.pdsprj  # Proteus simulation file
│   └── ragoQ3.*          # Compiled files
├── Project_Report.docx    # Detailed project documentation
└── README.md             # This file
```

## 🚀 Project Details

### Question 1: Digital Counter with LCD Display

**Features:**
- External interrupt-driven counter (RB0 pin)
- LCD display showing "COUNTER:" message
- Two-digit counter (00-99)
- Real-time display update on interrupt

**Pin Configuration:**
- **LCD Control**: PORTC (RS=RC0, RW=RC1, EN=RC2)
- **LCD Data**: PORTD (8-bit data bus)
- **Interrupt Input**: RB0 (external interrupt)

**Functionality:**
- Displays "COUNTER:" on the first line of LCD
- Shows current count value on the second line
- Counter increments on each external interrupt (falling edge)
- Automatic rollover from 99 to 00

### Question 2: Traffic Light Control System

**Features:**
- Automated traffic light sequence
- Precise timing control using software delays
- Standard traffic light pattern implementation

**Pin Configuration:**
- **Green LED**: RD0
- **Yellow LED**: RD1
- **Red LED**: RD2

**Traffic Light Sequence:**
1. **Green Light**: 3 seconds
2. **Yellow Light**: 3 seconds (warning)
3. **Red Light**: 2 seconds
4. **Yellow Light**: 1 second (prepare to go)
5. **Repeat cycle**

### Question 3: ADC with 7-Segment Display

**Features:**
- 10-bit ADC conversion
- Real-time analog signal monitoring
- Two-digit decimal display on 7-segment displays
- Automatic scaling and digit separation

**Pin Configuration:**
- **ADC Input**: AN0 (RA0)
- **Tens Digit Display**: PORTB
- **Units Digit Display**: PORTC

**Functionality:**
- Continuously reads analog input from AN0
- Converts 10-bit ADC result to decimal
- Separates tens and units digits
- Displays values on dual 7-segment displays
- Supports values from 00 to 99

## 🛠️ Technical Implementation

### Assembly Programming Features

- **Interrupt Service Routines (ISR)**: Implemented in Q1 for external interrupt handling
- **Modular Programming**: Each project uses subroutines for better code organization
- **Hardware Abstraction**: Pin definitions using #define directives
- **Timing Control**: Software-based delay routines
- **Register Management**: Proper bank switching and register initialization

### Key Assembly Techniques Used

- **Memory Management**: Efficient use of GPR registers
- **Lookup Tables**: 7-segment display codes in Q3
- **Arithmetic Operations**: Binary-to-decimal conversion
- **Interrupt Handling**: Context saving and restoration
- **Port Configuration**: Proper TRIS register setup

## 📊 Performance Characteristics

| Feature | Q1 | Q2 | Q3 |
|---------|----|----|---|
| **Interrupt Response** | < 5μs | N/A | N/A |
| **Display Update Rate** | On-demand | N/A | Continuous |
| **Timing Accuracy** | Interrupt-driven | ±1% | Real-time |
| **Power Consumption** | Medium | Low | Medium |

## 🔍 Testing and Simulation

All projects include Proteus simulation files (`.pdsprj`) for:
- Circuit verification
- Functionality testing
- Timing analysis
- Hardware validation before physical implementation

## 📚 Educational Objectives

This project demonstrates:
- **Microcontroller Programming**: Assembly language programming for PIC16F877A
- **Interrupt Handling**: External interrupt implementation and ISR design
- **Peripheral Interfacing**: LCD, LED, and 7-segment display control
- **Analog Processing**: ADC configuration and signal conversion
- **Timing Systems**: Software delay implementation and real-time control
- **Circuit Simulation**: Proteus-based design verification

## 👥 Contributors

- **Ragıp Günay** - ragipgunay09@gmail.com
- **Duygu Kamalak** - duygukamaalak@gmail.com

## 📝 Documentation

For detailed implementation notes, circuit diagrams, and test results, please refer to `Project_Report.docx`.

## 🔧 How to Use

1. **Setup Environment**:
   - Install MPLAB IDE
   - Install Proteus Design Suite
   - Configure PIC16F877A programmer

2. **Simulation**:
   - Open respective `.pdsprj` files in Proteus
   - Load compiled `.hex` files into PIC16F877A
   - Run simulation and test functionality

3. **Hardware Implementation**:
   - Build circuits according to simulation files
   - Program PIC16F877A with respective `.hex` files
   - Test with actual hardware components

## 📄 License

This project is created for educational purposes as part of the Microprocessors and Embedded Systems course.

---

*This project showcases fundamental concepts in embedded systems programming using PIC microcontrollers, demonstrating practical applications of digital systems, interrupt handling, and peripheral interfacing.* 
