import numpy
import subprocess
import sys
import socket
import time

regList = []
label_to_pc = {}

def initLabels(fileName):
    currentPC = 0
    with open(fileName,'r') as f:
        for line in f:
            for word in line.split():
                if "_" in word and ":" in word:
                    label_to_pc[word.strip(':')] = currentPC + 1
                currentPC += 1

def regSelect(reg, K):
    try:
        reg_name = reg.split(',')[0]
    except:
        reg_name = reg
    reg_num = -1
    if ('t' in reg or 's' in reg or 'v' in reg):
        reg_num = int(reg_name[1:])
        if reg_num > (K - 1):
            print("Invalid register, exiting.")
            sys.exit()
        if 's' in reg:
            reg_num += K
        elif 'v' in reg:
            reg_num += 2*K
    elif 'hp' in reg:
        reg_num = 3*K

    return reg_num

def bits_to_num(bitArray, W):
    # converts an array of bits to an integer
    try:
        num = int(bitArray)
        return num
    except:
        num = 0
        for bits in range(W):
            num = num + int(bitArray[bits]) * (2**bits)
        return num


def num_to_bits(num, W, func):
    if (func == 'umulh' or func == 'smulh'):
        bitArray = [num >> i & 1 for i in range(W*2)]
        subArray = bitArray[W:W*2 - 1]
        return subArray
    else:
        bitArray = [num >> i & 1 for i in range(W)]
        while (len(bitArray) < W): # padding
            bitArray.append(0)
        return bitArray

def send_str(sock, msg):
    sock.sendall(msg.encode())
    data = ""
    while "OK" not in data:
        try:
            data = sock.recv(16).decode()
        except ConnectionResetError:
            print(msg)
            sock.close()
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_address = ('localhost', 8080)
            time.sleep(1)
            sock.connect(server_address)
            data = sock.recv(16).decode()

def juliet_ee(fileName, W=8, K=16):
    # fileName : file holding Juliet instructions
    # W : word size in bits (8 bits by default)
    # K : number of registers (16 by default)

    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Connect the socket to the port where the server is listening
    server_address = ('localhost', 8080)
    sock.connect(server_address)

    P = ['0'] * 9999 # instruction memory
    pc = 0  # program counter
    pubTapeIndex = 0
    auxTapeIndex = 0
    memory = [0] * 2**16


    global regList
    for i in range(K*3+1):
        regList.append([0]*W)

    f = open(fileName)
    print_file = open("output.txt", "w")
    i = 0
    ri = [0] * W
    rj = [0] * W
    A = [0] * W # return value
    answer = [0] * W
    flag = 0

    # load program into instruction mem
    initLabels(fileName)
    for line in f:
        for word in line.split():
            P[i] = word
            i = i + 1
    f.close()

    while (pc >= 0):
        A = [0] * W
        ri = [0] * W
        rj = [0] * W
        answer = [0] * W

        func = P[pc]

        if (':' in func):
            pc += 1
            continue

        print(func)

        if (func == 'halt'):
            send_str(sock, "exit")
            return

        elif (func == 'chalt'):
            if (flag == 1):
                send_str(sock, "exit")
                return
            else:
                pc = pc + 1

        # functions on ciphertext

        elif (func == 'econst'):
            storeReg = P[pc + 1]
            ptxt_val = 0
            if (str(P[pc + 2]).isnumeric() == True): # shift value
                ptxt_val = int(P[pc + 2])
            else:
                ptxt_val = bits_to_num(regList[regSelect(P[pc + 2], K)], W)

            #subprocess.call("./e_alu " + str(W) + ' 14 ' + str(ptxt_val), shell=True)
            send_str(sock, str(W) + ' 14 ' + str(ptxt_val))
            pc = pc + 3
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'enot'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]

            #subprocess.call("./e_alu " + str(W) + ' 9 ' + ctxtOneFile, shell=True)
            send_str(sock, str(W) + ' 9 ' + ctxtOneFile)
            pc = pc + 3
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'esll'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            shift_val = 0
            if (str(P[pc + 3]).isnumeric() == True): # shift value
                shift_val = int(P[pc + 3])
            else:
                shift_val = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]

            #subprocess.call("./e_alu " + str(W) + ' 10 ' + ctxtOneFile + ' ' + str(shift_val), shell=True)
            send_str(sock, str(W) + ' 10 ' + ctxtOneFile + ' ' + str(shift_val))
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'eslr'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            shift_val = 0
            if (str(P[pc + 3]).isnumeric() == True): # shift value
                shift_val = int(P[pc + 3])
            else:
                shift_val = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]

            #subprocess.call("./e_alu " + str(W) + ' 11 ' + ctxtOneFile + ' ' + str(shift_val), shell=True)
            send_str(sock, str(W) + ' 11 ' + ctxtOneFile + ' ' + str(shift_val))
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'emux'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)
            ctxtThree = bits_to_num(regList[regSelect(P[pc + 4], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            if ctxtOne < 1:
                ctxtOneFile = content[0]
            else:
                ctxtOneFile = content[ctxtOne - 1]

            if ctxtTwo < 1:
                ctxtTwoFile = content[0]
            else:
                ctxtTwoFile = content[ctxtTwo - 1]

            if ctxtThree < 1:
                ctxtThreeFile = content[0]
            else:
                ctxtThreeFile = content[ctxtThree - 1]

            #subprocess.call("./e_alu " + str(W) + ' 12 ' + ctxtOneFile + " " + ctxtTwoFile + " " + ctxtThreeFile, shell=True)
            send_str(sock, str(W) + ' 12 ' + ctxtOneFile + " " + ctxtTwoFile + " " + ctxtThreeFile)
            pc = pc + 5
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'eand'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 0 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 0 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'enand'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 1 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 1 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'eor'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 2 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 2 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'enor'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 3 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 3 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'exor'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 4 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 4 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'exnor'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 5 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 5 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'ecmpeq'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 0", shell=True)
            send_str(sock, str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 0")
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'ecmpneq'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 5", shell=True)
            send_str(sock, str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 5")
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'ecmpg'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 2", shell=True)
            send_str(sock, str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 2")
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'ecmpl'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 1", shell=True)
            send_str(sock, str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 1")
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'ecmpgeq'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 3", shell=True)
            send_str(sock, str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 3")
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'ecmpleq'):
            storeReg = P[pc + 1]
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 2], K)], W)
            ctxtTwo = bits_to_num(regList[regSelect(P[pc + 3], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 4", shell=True)
            send_str(sock, str(W) + ' 13 ' + ctxtOneFile + " " + ctxtTwoFile + " 4")
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'esub'):
            storeReg = P[pc + 1]
            reg = P[pc + 2]
            secondReg = P[pc + 3]
            ri = regList[regSelect(reg, K)]
            rj = regList[regSelect(secondReg, K)]
            ctxtOne = bits_to_num(ri, W)
            ctxtTwo = bits_to_num(rj, W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]
            #subprocess.call("./e_alu " + str(W) + ' 6 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 6 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'eadd'):
            storeReg = P[pc + 1]
            reg = P[pc + 2]
            secondReg = P[pc + 3]
            ri = regList[regSelect(reg, K)]
            rj = regList[regSelect(secondReg, K)]
            ctxtOne = bits_to_num(ri, W)
            ctxtTwo = bits_to_num(rj, W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtOneFile = content[ctxtOne - 1]
            ctxtTwoFile = content[ctxtTwo - 1]
            #subprocess.call("./e_alu " + str(W) + ' 7 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 7 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        elif (func == 'emul' or func == 'emult'):
            storeReg = P[pc + 1]
            reg = P[pc + 2]
            secondReg = P[pc + 3]
            ri = regList[regSelect(reg, K)]
            rj = regList[regSelect(secondReg, K)]
            ctxtOne = bits_to_num(ri, W)
            ctxtTwo = bits_to_num(rj, W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            if ctxtOne < 1:
                ctxtOneFile = content[0]
            else:
                ctxtOneFile = content[ctxtOne - 1]

            if ctxtTwo < 1:
                ctxtTwoFile = content[0]
            else:
                ctxtTwoFile = content[ctxtTwo - 1]

            #subprocess.call("./e_alu " + str(W) + ' 8 ' + ctxtOneFile + " " + ctxtTwoFile, shell=True)
            send_str(sock, str(W) + ' 8 ' + ctxtOneFile + " " + ctxtTwoFile)
            pc = pc + 4
            intAnswer = int(subprocess.check_output(['grep', '-c', '$', 'ctxtMem.txt']))
            answer = num_to_bits(intAnswer, W, func)
            regList[regSelect(storeReg, K)] = answer

        # FIXME: This is exclusively for debugging
        elif (func == 'decrypt'):
            storeReg = P[pc + 1]
            reg = P[pc + 2]
            ri = regList[regSelect(reg, K)]
            ctxt = bits_to_num(ri, W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            ctxtFile = content[ctxt - 1]
            intAnswer = int(subprocess.call(['./client/decrypt', ctxtFile]))
            answer = num_to_bits(intAnswer, W, func)
            pc = pc + 3;
            regList[regSelect(storeReg, K)] = answer

        # plaintext functions of the form: ri rj A
        elif (func == 'and' or func == 'or' or func == 'xor' or func == 'add' or func == 'sub' or func == 'mull' or func == 'mult' or func == 'umulh' or func == 'smulh' or func == 'udiv' or func == 'umod' or func == 'shl' or func == 'shr' or func == 'slt'):
            reg = P[pc + 2]
            rj = regList[regSelect(reg, K)]
            secondArg = P[pc + 3]

            if (str(secondArg).isnumeric() == True): # immediate value
                temp = int(secondArg)
                if (W == 8):
                    temp2 = "{0:{fill}8b}".format(temp, fill='0')
                elif (W == 16):
                    temp2 = "{0:{fill}16b}".format(temp, fill='0')
                elif (W == 32):
                    temp2 = "{0:{fill}32b}".format(temp, fill='0')
                elif (W == 64):
                    temp2 = "{0:{fill}64b}".format(temp, fill='0')
                elif (W == 4):
                    temp2 = "{0:{fill}4b}".format(temp, fill='0')
                for j in range(W):
                    A[j] = int(temp2[j])
                A.reverse()

            else:
                A = regList[regSelect(secondArg, K)]

            if (func == 'and'):
                for j in range(W):
                    answer[j] = rj[j] & A[j]

            elif (func == 'or'):
                for j in range(W):
                    answer[j] = rj[j] | A[j]

            elif (func == 'xor'):
                for j in range(W):
                    answer[j] = rj[j] ^ A[j]

            elif (func == 'add'):
                operandOne = bits_to_num(A, W)
                operandTwo = bits_to_num(rj, W)

                intAnswer = operandOne + operandTwo
                if (intAnswer > (2**(W) - 1)):
                    flag = 1

                answer = num_to_bits(intAnswer, W, func)

            elif (func == 'sub'):
                operandOne = bits_to_num(rj, W)
                operandTwo = bits_to_num(A, W)

                intAnswer = operandOne - operandTwo

                #must check for underflow
                if (intAnswer < 0):
                    flag = 1

                answer = num_to_bits(intAnswer, W, func)

            elif (func == 'mull' or func == 'mult'):
                operandOne = bits_to_num(rj, W)
                operandTwo = bits_to_num(A, W)

                intAnswer = operandOne * operandTwo
                if (intAnswer > (2**(2*W) - 1)):
                    flag = 1

                answer = num_to_bits(intAnswer, W, func)

            elif (func == 'umulh' or func == 'smulh'):
                operandOne = bits_to_num(rj, W)
                operandTwo = bits_to_num(A, W)

                intAnswer = operandOne * operandTwo
                if (intAnswer > (2**(2*W) - 1)):
                    flag = 1

                answer = num_to_bits(intAnswer, W, func)

            elif (func == 'udiv'):
                operandOne = bits_to_num(rj, W)
                operandTwo = bits_to_num(A, W)

                if (operandTwo == 0):
                    print('Error: Divide by Zero')
                    flag = 1
                    continue

                intAnswer = int(operandOne / operandTwo)
                answer = num_to_bits(intAnswer, W, func)

            elif (func == 'umod'):
                operandOne = bits_to_num(rj, W)
                operandTwo = bits_to_num(A, W)

                if (operandTwo == 0):
                    print('Error: Divide by Zero')
                    flag = 1
                    continue

                intAnswer = int(operandOne % operandTwo)
                answer = num_to_bits(intAnswer, W, func)


            elif (func == 'shr'):
                operandTwo = bits_to_num(A, W)
                answer = rj
                for j in range(operandTwo):
                    answer = numpy.roll(answer, 1)

                if (operandTwo == (W - 1)):
                    print('Warning: shifting by MSB')
                    flag = 1

            elif (func == 'shl'):
                operandTwo = bits_to_num(A, W)
                answer = rj
                for j in range(operandTwo):
                    answer = numpy.roll(answer, -1)

                if (operandTwo == (W - 1)):
                    print('Warning: shifting by LSB')
                    flag = 1

            elif (func == 'slt'):
                operandOne = bits_to_num(rj, W)
                operandTwo = bits_to_num(A, W)

                if operandOne < operandTwo:
                    answer = 1
                else:
                    answer = 0

                intAnswer = [0] * W

                if (W == 8):
                    answer = "{0:{fill}8b}".format(answer, fill='0')
                elif (W == 16):
                    answer = "{0:{fill}16b}".format(answer, fill='0')
                elif (W == 32):
                    answer = "{0:{fill}32b}".format(answer, fill='0')
                elif (W == 64):
                    answer = "{0:{fill}64b}".format(answer, fill='0')
                for j in range(W):
                    intAnswer[j] = int(answer[j])
                intAnswer.reverse()

            storeReg = P[pc + 1]
            regList[regSelect(storeReg, K)] = intAnswer
            pc = pc + 4

        elif (func == 'j'):
            newPC = P[pc + 1]
            if "__" in newPC:
                A = label_to_pc[newPC]
            elif (str(newPC).isnumeric() == True):
                A = int(newPC)
            else:
                A = bits_to_num(regList[regSelect(newPC, K)], W)

            pc = A

        elif (func == 'beq'):
            firstArg = P[pc + 1]
            secondArg = P[pc + 2]
            newPc = P[pc + 3]

            B = -1
            C = -1

            if str(firstArg).isnumeric() == False:
                A = bits_to_num(regList[regSelect(firstArg, K)], W)
            else:
                A = int(firstArg)

            if "zero" in secondArg:
                B = 0
            elif str(secondArg).isnumeric() == False:
                B = bits_to_num(regList[regSelect(secondArg, K)], W)
            else:
                B = int(secondArg)

            if "__" in newPc:
                C = label_to_pc[newPc]
            elif str(newPC).isnumeric() == False:
                C = bits_to_num(regList[regSelect(newPc, K)], W)
            else:
                C = int(newPc)

            if A == B:
                pc = C
            else:
                pc = pc + 4

        elif (func == 'move' or func == 'cmov' or func == 'not' or func == 'cmpe' or func == 'cmpa' or func == 'cmpae' or func == 'cmpg' or func == 'cmpge'):
            secondArg = P[pc + 2]

            if (str(secondArg).isnumeric() == True): # immediate value
                temp = int(secondArg)
                if (W == 8):
                    temp2 = "{0:{fill}8b}".format(temp, fill='0')
                elif (W == 16):
                    temp2 = "{0:{fill}16b}".format(temp, fill='0')
                elif (W == 32):
                    temp2 = "{0:{fill}32b}".format(temp, fill='0')
                elif (W == 64):
                    temp2 = "{0:{fill}64b}".format(temp, fill='0')
                elif (W == 4):
                    temp2 = "{0:{fill}4b}".format(temp, fill='0')
                for j in range(W):
                    A[j] = int(temp2[j])
                A.reverse()

            else:
                A = regList[regSelect(secondArg, K)]

            if (func == 'move'):
                storeReg = P[pc + 1]
                regList[regSelect(storeReg, K)] = A

            elif (func == 'cmov'):
                if (flag == 1):
                    storeReg = P[pc + 1]
                    regList[regSelect(storeReg, K)] = A

            elif (func == 'not'):
                storeReg = P[pc + 1]
                regList[regSelect(storeReg, K)] = ~A

            elif (func == 'cmpe'):
                storeReg = P[pc + 1]
                if regList[regSelect(storeReg, K)] == A:
                    flag = 1

            elif (func == 'cmpa' or func == 'cmpg'):
                arg2 = bits_to_num(A, W)
                arg1 = bits_to_num(regList[regSelect(storeReg, K)], W)

                if (arg1 > arg2):
                    flag = 1

            elif (func == 'cmpae' or func == 'cmpge'):
                arg2 = bits_to_num(A, W)
                arg1 = bits_to_num(regList[regSelect(storeReg, K)], W)

                if (arg1 >= arg2):
                    flag = 1

            pc = pc + 3

        elif (func == 'print'):
            reg = P[pc + 1]

            print_file.write(str(bits_to_num(regList[regSelect(reg, K)], W)))
            print_file.write("\n")

            pc = pc + 2

        elif (func == 'pdec'):
            reg = P[pc + 1]

            intReg = bits_to_num(regList[regSelect(reg, K)], W)
            print_file.write(str(intReg) + "\n")

            pc = pc + 2

        elif (func == 'cmpl'):
            reg = P[pc + 1]
            secondArg = P[pc + 2]
            thirdArg = P[pc + 3]
            secondArg = int(bits_to_num(regList[regSelect(secondArg, K)], W))

            if str(thirdArg).isnumeric() == False:
                thirdArg = int(bits_to_num(regList[regSelect(thirdArg, K)], W))
            else:
                thirdArg = int(thirdArg)

            if (secondArg < thirdArg):
                regList[regSelect(reg, K)] = num_to_bits(1, W, func)
            else:
                regList[regSelect(reg, K)] = num_to_bits(0, W, func)

            pc = pc + 4

        elif (func == 'cmpleq'):
            reg = P[pc + 1]
            secondArg = P[pc + 2]
            thirdArg = P[pc + 3]
            secondArg = int(bits_to_num(regList[regSelect(secondArg, K)], W))

            if str(thirdArg).isnumeric() == False:
                thirdArg = int(bits_to_num(regList[regSelect(thirdArg, K)], W))
            else:
                thirdArg = int(thirdArg)

            if (secondArg < thirdArg or secondArg == thirdArg):
                regList[regSelect(reg, K)] = num_to_bits(1, W, func)
            else:
                regList[regSelect(reg, K)] = num_to_bits(0, W, func)

            pc = pc + 4

        elif (func == 'answer'):
            ctxtOne = bits_to_num(regList[regSelect(P[pc + 1], K)], W)

            with open("ctxtMem.txt") as f:
                content = f.readlines()
            content = [x.strip() for x in content]
            f.close()

            if ctxtOne < 1:
                ctxtOneFile = content[0]
            else:
                ctxtOneFile = content[ctxtOne - 1]
            subprocess.call("cp " + ctxtOneFile + " output.data", shell=True)
            send_str(sock, "exit")

            return

        #sw t2, 0(t3)
        elif (func == 'sw'):
            reg = P[pc + 1]

            memOffset = 0

            ri = regList[regSelect(reg, K)]
            memAddress = P[pc + 2]

            mem_addr = memAddress.split('(')

            if (str(mem_addr[0]).isnumeric() == True):
                memOffset = int(mem_addr[0])
            else:
                memOffset = bits_to_num(regList[regSelect(mem_addr[0], K)], W)

            mem_addr[1].strip(')')

            mem_num = bits_to_num(regList[regSelect(mem_addr[1].strip(')'), K)], W)

            for j in range(W):
                memory[mem_num*W + W*memOffset + j] = ri[j]

            pc = pc + 3

        elif (func == 'lw'):
            reg = P[pc + 1]

            memOffset = 0

            memAddress = P[pc + 2]

            mem_addr = memAddress.split('(')

            if (str(mem_addr[0]).isnumeric() == True):
                memOffset = int(mem_addr[0])
            else:
                memOffset = bits_to_num(regList[regSelect(mem_addr[0], K)], W)

            mem_addr[1].strip(')')

            mem_num = bits_to_num(regList[regSelect(mem_addr[1].strip(')'), K)], W)

            for j in range(W):
                answer[j] = memory[mem_num*W + W*memOffset + j]

            regList[regSelect(reg, K)] = answer

            pc = pc + 3

        elif (func == 'load'):

            memAddress = P[pc + 2]
            if (str(memAddress).isnumeric() == True):
                memIndex = int(memAddress)
            else:
                memIndex = bits_to_num(regList[regSelect(memAddress, K)], W)

            for j in range(W):
                answer[j] = int(memory[memIndex + j])

            storeReg = P[pc + 1]
            regList[regSelect(storeReg, K)] = answer

            pc = pc + 3

        elif (func == 'secread'):
            tape = open("tapes/priv.txt", 'r')
            tapeFiles = tape.readlines()
            tapeFiles = [x.strip() for x in tapeFiles]
            if auxTapeIndex > (len(tapeFiles) - 1):
                print("No more values in private tape!")
                return
            else:
                ctxtTapeFile = tapeFiles[auxTapeIndex]
            tape.close()
            if ctxtTapeFile == "":
                print("Invalid file pointer to ctxt. Exiting")
                return
            ctxtMem = open("ctxtMem.txt", 'a')
            ctxtMem.write(ctxtTapeFile + '\n')
            ctxtMem.close()
            ctxtMem = open("ctxtMem.txt", 'r')
            intAnswer = 0
            for line in ctxtMem:
                intAnswer = intAnswer + 1
            answer = num_to_bits(intAnswer, W, func)
            ctxtMem.close()
            auxTapeIndex = auxTapeIndex + 1

            storeReg = P[pc + 1]
            regList[regSelect(storeReg, K)] = answer

            flag = 0
            pc = pc + 2

        elif (func == 'pubread'):
            tape = open("tapes/pub.txt", 'r')
            tapeVals = tape.readlines()
            tapeVals = [x.strip() for x in tapeVals]
            if pubTapeIndex > (len(tapeVals) - 1):
                print("No more values in public tape!")
                return
            else:
                currVal = tapeVals[pubTapeIndex]
            tape.close()
            if currVal.isnumeric() == False:
                print("Public tape is formatted incorrectly. Exiting.")
                return
            answer = num_to_bits(int(currVal), W, func)
            storeReg = P[pc + 1]
            regList[regSelect(storeReg, K)] = answer
            pubTapeIndex += 1

            flag = 0
            pc = pc + 2

        else: # either label or invalid instruction
            if ':' in func: # label
                continue
            else:
                print("Invalid instruction:", func)
                print(P[pc-1], P[pc+1])
                break

start = time.time()
juliet_ee("Benchmarks/PIR.asm", 8, 16)
print("Time elapsed: ", time.time() - start)
