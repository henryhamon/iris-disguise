[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-disguise) [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-disguise&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-disguise) [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-disguise&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-disguise)

# ![Iris Disguise](assets/fake.png?raw=true) iris-disguise

> **iris-Disguise** is a tool for Data Anonymization on IterSystems IRIS.

**iris-Disguise** helps you to build anonymized production data dumps which you can use for performance testing, security testing, debugging and development.

![disguise](https://media.giphy.com/media/3oEjHPuFDT0CpthWCY/giphy.gif)

> Data anonymization is a type of information sanitization whose intent is privacy protection. It is the process of removing personally identifiable information from data sets, so that the people whom the data describe remain anonymous. [Wikipedia](https://en.wikipedia.org/wiki/Data_anonymization)

**iris-Disguise** provides a set of anonymization strategies:
* **Destruction**  _Sometimes the fastest and the best approach to anonymize a data is to replace all the values with the word CONFIDENTIAL_
* **Randomization** _Generate purely random data_
* **Partial Masking** _leaves out some part of the data_
* **Scramble** _Given "ABCDEFG", return something like "GEFBDCA"_
* **Shuffling** _mixes values within the same columns_

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
