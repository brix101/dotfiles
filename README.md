# Arch Linux with Sway and Neovim

Welcome to my Arch Linux setup featuring the Sway tiling window manager and Neovim text editor!

## Introduction

This repository contains the configuration files and setup instructions for my personalized Arch Linux environment. With Sway, I enjoy a lightweight and efficient tiling window manager that utilizes the Wayland protocol, providing a modern and streamlined user experience. Neovim serves as my primary text editor, offering powerful features and extensibility, ideal for coding and general text editing tasks.

## Features

- **Sway Tiling Window Manager**: Enjoy efficient window management with Sway, leveraging the power of Wayland for a smooth desktop experience.
- **Neovim Text Editor**: Enhance your productivity with Neovim, featuring extensibility, robust plugin support, and a familiar Vim keybinding interface.
- **Dotfiles**: Access my customized configuration files for Sway, Neovim, and other applications to replicate my setup or draw inspiration for your own configuration.

## Getting Started

### Prerequisites

Before proceeding, ensure you have the following installed:

- Arch Linux (or an Arch-based distribution)
- Sway (and its dependencies)
- Neovim (and any desired plugins or dependencies)
- Git (to clone this repository)

### Installation

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/Brix101/dotfiles.git
   ```

2. Copy the configuration files to their respective locations:

   ```bash
   cd dotfiles

   # Neovim
   cp -r ./* ~/
   ```

3. Restart Sway or reload its configuration:

   ```bash
   swaymsg reload
   ```
