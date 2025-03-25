from pathlib import Path


oacCodes = {
    "outloc" : 0b00001,
    "outr" : 0b00010
}

#memory ops
moCodes = {
    "li" : 0b110
}


class Assembler:
    def __init__(self, filename):
        with open(filename, "r") as file: 
            self.code = file.readlines()
            self.filename = Path(filename)
            self.hex = [0]*len(self.code)

    #one argument codes
    def convertOAC(self, line):
        if (line[0] == "outloc"):
            operation = oacCodes[line[0]]
            value = int(line[1])
            out = (operation << 11) | value
        elif (line[0] == "outr"):
            operation = oacCodes[line[0]]
            registerNum = int(line[1].strip(",").strip("x"))
            out = (operation << 11) | (0 << 6) | registerNum

        return f"{out:04x}"

    def convertMO(self, line):
        if (line[0] == "li"):
            opcode = moCodes[line[0]]
            registerNum = int(line[1].strip(",").strip("x"))
            value = int(line[2])
            out = (opcode << 13) | (registerNum << 8) | value
        return f"{out:04x}"

    
    def convertValue(self, line):
        return f"{int(line[1]):04x}"

    def convertCode(self):
        for idx, line in enumerate(self.code):
            line = line.strip("\n").split()
            if "value:" in line:
                self.hex[idx] = self.convertValue(line)
            if line[0] in oacCodes:
                self.hex[idx] = self.convertOAC(line)
            if line[0] in moCodes:
                self.hex[idx] = self.convertMO(line)
            if "endprog" in line: 
                self.hex[idx] = "7777"


    def write(self):
        filename = self.filename.stem + ".hex"
        with open(filename, "w") as file:
            for line in self.hex:
                file.write(line+"\n")


if __name__ == "__main__":
    a = Assembler("../program.txt")
    a.convertCode()
    a.write()
