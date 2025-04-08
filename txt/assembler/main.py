from pathlib import Path

memory_access = {
    "li" : 0b0011,
    "mov" : 0b0001
}

debug_codes = {
    "outr" : 0b0010,
}


class Assembler:
    def __init__(self, filename):
        with open(filename, "r") as file: 
            self.code = file.readlines()
            self.filename = Path(filename)
            self.hex = [0]*len(self.code)

    #one argument codes
    def convertDEBUG(self, line):
        out = 0
        if (line[0] == "outr"):
            operation = debug_codes[line[0]]
            registerNum = int(line[1].strip(",").strip("r"))
            out = (operation << 21) | (registerNum << 12)

        return f"{out:08x}"

    def convertMA(self, line):
        if (line[0] == "li"):
            opcode = memory_access[line[0]]
            registerNum = int(line[1].strip(",").strip("r"))
            value = int(line[2])
            out = (opcode << 21) | (registerNum << 12) | value
        elif (line[0] == "mov"):
            opcode = memory_access[line[0]]
            destRegister = int(line[1].strip(",").strip("r"))
            sourceRegister = int(line[2].strip(",").strip("r"))
            out = (opcode << 21) | (destRegister << 12) | sourceRegister
            

        return f"{out:08x}"

    def convertCode(self):
        for idx, line in enumerate(self.code):
            line = line.strip("\n").split()
            if line[0] in memory_access:
                self.hex[idx] = self.convertMA(line)
            if line[0] in debug_codes:
                self.hex[idx] = self.convertDEBUG(line)

            if "endprog" in line: 
                self.hex[idx] = "ffffffff"


    def write(self):
        filename = self.filename.stem + ".hex"
        with open(filename, "w") as file:
            for line in self.hex:
                file.write(line+"\n")


if __name__ == "__main__":
    a = Assembler("../program.txt")
    a.convertCode()
    a.write()
