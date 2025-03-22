from pathlib import Path


oacCodes = {
    "outloc" : 0x01
}

class Assembler:
    def __init__(self, filename):
        with open(filename, "r") as file: 
            self.code = file.readlines()
            self.filename = Path(filename)
            self.hex = [0]*len(self.code)

    #one argument codes
    def convertOAC(self, line):
        operation = oacCodes[line[0]]
        value = int(line[1])
        out = (operation << 8) | value
        return f"{out:04x}"

    def convertCode(self):
        for idx, line in enumerate(self.code):
            line = line.strip("\n").split()
            if line[0] in oacCodes:
                self.hex[idx] = self.convertOAC(line)

    
    def write(self):
        filename = self.filename.stem + ".hex"
        with open(filename, "w") as file:
            for line in self.hex:
                file.write(line+"\n")


if __name__ == "__main__":
    a = Assembler("../convert.txt")
    a.convertCode()
    a.write()
