# Wheely test

## General Information
Test application on Ruby

See the [task.md](./task.md) for more details

### Prerequirements
You need the following software to be installed on your system:
- [Docker](https://docs.docker.com/get-docker/)
- [Git](https://gitlab.com/help/topics/git/index.md)

### Getting Started

1.  Clone the repo and navigate to the target folder.

        $ git clone git@github.com:Xayc73/fake_eta.git
        $ cd fake_eta
    
2.  Build container at the command prompt:

        $ docker build -t fake_eta ./
    
3.  Run necessary command at the command prompt:

        $ docker run --rm -v "$PWD":/app fake_eta command

### Run tests

        $ docker run --rm -v "$PWD":/app fake_eta rspec tests

### Run lint

        $ docker run --rm -v "$PWD":/app fake_eta rubocop