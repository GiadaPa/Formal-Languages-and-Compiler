# Formal-Languages-and-Compiler
Project for Formal Languages and Compiler Course @ UniBz

This project will allow you to generate an HTML snippet out of an exported Figma JSON file.

## Table of contents

- [Usage](#usage)
- [Source code](#source-code)
- [Authors](#authors)
- [Project status](#project-status)

## Usage

Create a template on Figma and exploit the API to export the data formatted in JSON with the following command:

```
curl -sH 'Authorization: Bearer <TOKEN>'
    'https://api.figma.com/v1/files/...'
    | python -m json.tool
```

Find more information on the [Figma API doc](https://www.figma.com/developers/api)

**Suggestion: keep all your exported files in the `files/` folder.**

To generate a HTML code snippet, run a statement like this:

```
make all JSON="files/example"
```

You can now use the snippet in the body of a full structured HTML file.

### Attributes

#### JSON

This attribute specifies the filename of the json you want to generate HTML from.

The generated file will have the same same name. The extension will be `.html`

**Note: do not specify extension of the file in the attribute value, i.e. `.json`**

## Source code

Get a copy of the repository:

```bash
git clone git@github.com:GiadaPa/Formal-Languages-and-Compilers.git
```
or alternatively:
```bash
git clone https://github.com/GiadaPa/Formal-Languages-and-Compilers.git
```

Change directory:

```bash
cd Formal-Languages-and-Compilers/src/
```

## Authors

- **Giada Palma** - [GiadaPa](https://github.com/GiadaPa/)
- **Gabriele De Candido** - [lelebus](https://github.com/lelebus)

## Project status

The JSON object specifications, exported by the Figma API, have been changed, since the beginning of the project. For time reasons,  the compiler was not updated accordingly.

You can find an example export .json file in the `files/` folder.