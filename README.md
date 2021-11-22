[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-disguise)

# ![Iris Disguise](assets/fake.png?raw=true) iris-disguise

> **iris-Disguise** is a tool for Data Anonymization on IterSystems IRIS.

**iris-Disguise** that helps you build anonymized production data dumps which you can use for performance testing, security testing, debugging and development.

![disguise](https://media.giphy.com/media/3oEjHPuFDT0CpthWCY/giphy.gif)

> Data anonymization is a type of information sanitization whose intent is privacy protection. It is the process of removing personally identifiable information from data sets, so that the people whom the data describe remain anonymous. [Wikipedia](https://en.wikipedia.org/wiki/Data_anonymization)

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation

Open terminal and clone/git pull the repo into any local directory as shown below:

```
git clone https://github.com/henryhamon/iris-disguise.git
```

Open the terminal in this directory and run:

```
docker-compose build
```

### Installation with ZPM

```
zpm:USER>install iris-disguise
```

## How to Test

### Unit Test

Open IRIS terminal:

```
docker-compose exec iris iris session iris -U IRISAPP
```

```
Set ^UnitTestRoot = "/irisrun/repo/src/iris/dc/Test/Disguise/"
Do ##class(%UnitTest.Manager).RunTest("","/loadudl")
```

## Credits
Icon by Flaticon from [www.flaticon.com](https://www.flaticon.com/authors/smashicons)

## Author ##

 * Henry "HammZ" Hamon [github](https://github.com/henryhamon)
