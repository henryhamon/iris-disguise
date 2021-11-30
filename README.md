[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-disguise) [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-disguise&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-disguise) [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-disguise&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-disguise)

# ![Iris Disguise](assets/fake.png?raw=true) iris-disguise

> **iris-Disguise** is a tool for Data Anonymization on IterSystems IRIS.

**iris-Disguise** helps you to build anonymized production data dumps which you can use for performance testing, security testing, debugging and development.

![disguise](https://media.giphy.com/media/3oEjHPuFDT0CpthWCY/giphy.gif)

> Data anonymization is a type of information sanitization whose intent is privacy protection. It is the process of removing personally identifiable information from data sets, so that the people whom the data describe remain anonymous. [Wikipedia](https://en.wikipedia.org/wiki/Data_anonymization)

**iris-Disguise** provides a set of anonymization strategies:
* **Destruction**  _Sometimes the fastest and the best approach to anonymize a data is to replace all the values with the word CONFIDENTIAL_
* **Randomization** _Generate purely random data_
* **Faking** _Replace data with random **but plausible** fake values_
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

## How to Use

### Destruction

This strategy will replace a entire column with a word ('CONFIDENTIAL' is the default).

```
Do ##class(dc.Disguise.Strategy).Destruction("classname", "propertyname", "Word to replace")
```

The third parameter is optional. If not provided, the word 'CONFIDENTIAL' will be used.

### Scramble

This strategy will scrambling all characters in a property.

```
Do ##class(dc.Disguise.Strategy).Scramble("classname", "propertyname")
```

### Shuffling

Shuffling will rearrange all values in a given property. Is not a masking strategy because it works "verticaly".
This strategy is useful for relatinship because referential integrity will be kept.
Until this version, this method only works on **one-to-many relationships**.

```
Do ##class(dc.Disguise.Strategy).Shuffling("classname", "propertyname")
```

### Partial Masking

This strategy will obfuscate the part of data, a credit card number for example, can be replaced by 456X XXXX XXXX X783

```
Do ##class(dc.Disguise.Strategy).PartialMasking("classname", "propertyname", prefixLength, suffixLength, "mask")
```

PrefixLength, suffixLength and mask are optional. If not provided, the default values will be used.

### Randomization

This strategy will generate purely random data. There are three types of randomization: integer, numeric and date.

```
Do ##class(dc.Disguise.Strategy).Randomization("classname", "propertyname", "type", from, to)
```

**type**: "integer", "numeric" or "date". "integer" is the default.

from and to are optional. Is to define the range of randomization.
For integer type the default range is 1 to 100. For numeric type the default range is 1.00 to 100.00.

### Fake Data

The idea of Faking is to replace data with random but plausible values.
**iris-Disguise** provides a small set of methods to generate fake data.

```
Do ##class(dc.Disguise.Strategy).Fake("classname", "propertyname", "type")
```

**type**: "firstname", "lastname", "fullname", "company", "country", "city" and "email"

### Wearing the disguise Glasses

Another way to use **iris-Disguise** is _wearing the disguise glasses_. In a persistent class, you can extent the **dc.Disguise.Glasses** class and change any property with the data type with the strategy of your choice.
After that just call the .DisguiseProcess() method on the class. All the values will be replaced using the strategy of the data type.

 Data types:
 * PartialMaskString
 * RandomInteger
 * RandomNumeric
 * FakeString: FieldStrategy parameters: "FIRSTNAME", "LASTNAME", "FULLNAME", "COMPANY", "COUNTRY", "CITY" AND "EMAIL"
 * String: FieldStrategy parameters: "DESTRUCTION","SCRAMBLE" AND "SHUFFLING"

## Credits
Icon by Flaticon from [www.flaticon.com](https://www.flaticon.com/authors/smashicons)

## Author ##

 * Henry "HammZ" Hamon [github](https://github.com/henryhamon)
