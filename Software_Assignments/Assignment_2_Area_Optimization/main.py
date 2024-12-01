from itertools import product

# part(a)

gate_delays_file = open("gate_delays.txt", "r")
gate_delays = {}
gate_delays["NAND2"] = []
gate_delays["AND2"] = []
gate_delays["NOR2"] = []
gate_delays["OR2"] = []
gate_delays["INV"] = []
for line in gate_delays_file.readlines():
    if line[0:2] == "//":
        continue
    else:
        x = line.split()
        if x != []:
            gate_delays[x[1]].append((float(x[2]), float(x[3])))

gate_delays_file.close()

gate_delays["NAND2"].sort()
gate_delays["AND2"].sort()
gate_delays["NOR2"].sort()
gate_delays["OR2"].sort()
gate_delays["INV"].sort()

primary_inputs = []
primary_outputs = []
internal_signals = []
dff_inputs = []
dff_outputs = []
out_circuit_graph = {}
out_generator_gate = {}
out_delay_evaluated = {}
out_delay = {}
circuit_file = open("circuit.txt", "r")
parse = []
parse_len = 0

for line in circuit_file.readlines():
    if line[0:2] == "//":
        continue
    else:
        for word in line.split():
            parse.append(word)
            parse_len += 1

i = 0
key = [
    "PRIMARY_INPUTS",
    "PRIMARY_OUTPUTS",
    "INTERNAL_SIGNALS",
    "DFF",
    "INV",
    "OR2",
    "AND2",
    "NOR2",
    "NAND2",
]

while i < parse_len:
    if parse[i] == "PRIMARY_INPUTS":
        j = i + 1
        while (parse[j] not in key) and j < parse_len:
            primary_inputs.append(parse[j])
            out_delay_evaluated[parse[j]] = True
            out_delay[parse[j]] = 0
            j = j + 1
        i = j

    elif parse[i] == "PRIMARY_OUTPUTS":
        j = i + 1
        while (parse[j] not in key) and j < parse_len:
            primary_outputs.append(parse[j])
            out_delay_evaluated[parse[j]] = False
            out_delay[parse[j]] = None
            j = j + 1
        i = j

    elif parse[i] == "INTERNAL_SIGNALS":
        j = i + 1
        while (parse[j] not in key) and j < parse_len:
            internal_signals.append(parse[j])
            out_delay_evaluated[parse[j]] = False
            out_delay[parse[j]] = None
            j = j + 1
        i = j

    elif parse[i] == "INV":
        out_circuit_graph[parse[i + 2]] = parse[i + 1]
        out_generator_gate[parse[i + 2]] = ["INV"]
        i = i + 3

    elif parse[i] == "OR2":
        out_circuit_graph[parse[i + 3]] = (parse[i + 1], parse[i + 2])
        out_generator_gate[parse[i + 3]] = ["OR2"]
        i = i + 4

    elif parse[i] == "AND2":
        out_circuit_graph[parse[i + 3]] = (parse[i + 1], parse[i + 2])
        out_generator_gate[parse[i + 3]] = ["AND2"]
        i = i + 4

    elif parse[i] == "NOR2":
        out_circuit_graph[parse[i + 3]] = (parse[i + 1], parse[i + 2])
        out_generator_gate[parse[i + 3]] = ["NOR2"]
        i = i + 4

    elif parse[i] == "NAND2":
        out_circuit_graph[parse[i + 3]] = (parse[i + 1], parse[i + 2])
        out_generator_gate[parse[i + 3]] = ["NAND2"]
        i = i + 4
    else:
        dff_inputs.append(parse[i + 1])
        dff_outputs.append(parse[i + 2])
        out_delay_evaluated[parse[i + 2]] = True
        out_delay[parse[i + 2]] = 0
        i = i + 3

circuit_file.close()

for signal in out_generator_gate:
    x = out_generator_gate[signal]
    x.append(gate_delays[x[0]][0])


def find_out_delay(x):
    if out_delay_evaluated[x]:
        return out_delay[x]
    else:
        y = find_out_delay(out_circuit_graph[x][0])
        for i in out_circuit_graph[x][1:]:
            if y < find_out_delay(i):
                y = out_delay[i]
        out_delay[x] = y + out_generator_gate[x][1][0]
        out_delay_evaluated[x] = True
        return out_delay[x]


ans = []
for i in dff_inputs:
    temp = find_out_delay(i)
    ans.append(temp)
for i in primary_outputs:
    if i not in dff_inputs:
        temp = find_out_delay(i)
        ans.append(temp)

longest_delay_file = open("longest_delay.txt", "w")
answer = max(ans)
longest_delay_file.writelines(str(answer))


# part(b)
delay_constraint_file = open("delay_constraint.txt", "r")
for line in delay_constraint_file.readlines():
    for i in line.split():
        max_delay = float(i)
delay_constraint_file.close()

n = len(out_generator_gate)


def perm_generator_with_repetitions(lst, length=None):
    if length is None:
        length = len(lst)

    for perm in product(lst, repeat=length):
        yield perm


min_area = float("inf")
res = 0
area = 0

if n < 14:
    for perm in perm_generator_with_repetitions([0, 1, 2], n):
        for signal, i in zip(out_generator_gate, perm):
            out_generator_gate[signal][1] = gate_delays[out_generator_gate[signal][0]][
                i
            ]

        for signal in out_delay_evaluated:
            out_delay_evaluated[signal] = False
            out_delay[signal] = None
        for signal in primary_inputs:
            out_delay_evaluated[signal] = True
            out_delay[signal] = 0
        for signal in dff_outputs:
            out_delay_evaluated[signal] = True
            out_delay[signal] = 0

        for i in dff_inputs:
            temp = find_out_delay(i)
            if temp > res:
                res = temp

        for i in primary_outputs:
            if i not in dff_inputs:
                temp = find_out_delay(i)
                if temp > res:
                    res = temp

        if res > max_delay:
            continue
        else:
            area = 0
            for signal in out_generator_gate:
                area += out_generator_gate[signal][1][1]

            if area < min_area:
                min_area = area

else:
    s = ""
    for i in range(n):
        s += "0"
    lst = [s]
    curr_size = 1
    next_size = curr_size

    for i in range(n):
        x = 50 * (i + 1)
        count = 0
        next_size = curr_size
        for j in range(curr_size):
            y = lst[j]
            y = y[:i] + "1" + y[i + 1 :]
            k = 0
            for signal in out_generator_gate:
                out_generator_gate[signal][1] = gate_delays[
                    out_generator_gate[signal][0]
                ][int(y[k])]
                k += 1

            for signal in out_delay_evaluated:
                out_delay_evaluated[signal] = False
                out_delay[signal] = None

            for signal in primary_inputs:
                out_delay_evaluated[signal] = True
                out_delay[signal] = 0

            for signal in dff_outputs:
                out_delay_evaluated[signal] = True
                out_delay[signal] = 0

            res = 0
            for signal in dff_inputs:
                temp = find_out_delay(signal)
                if temp > res:
                    res = temp

            for signal in primary_outputs:
                if signal not in dff_inputs:
                    temp = find_out_delay(signal)
                    if temp > res:
                        res = temp

            if res <= max_delay:
                lst.append(y)
                count += 1
                next_size += 1
                area = 0
                for signal in out_generator_gate:
                    area += out_generator_gate[signal][1][1]

                if area < min_area:
                    min_area = area

            if count > x:
                break

            y = y[:i] + "2" + y[i + 1 :]
            k = 0

            for signal in out_generator_gate:
                out_generator_gate[signal][1] = gate_delays[
                    out_generator_gate[signal][0]
                ][int(y[k])]
                k += 1

            for signal in out_delay_evaluated:
                out_delay_evaluated[signal] = False
                out_delay[signal] = None

            for signal in primary_inputs:
                out_delay_evaluated[signal] = True
                out_delay[signal] = 0

            for signal in dff_outputs:
                out_delay_evaluated[signal] = True
                out_delay[signal] = 0

            res = 0
            for signal in dff_inputs:
                temp = find_out_delay(signal)
                if temp > res:
                    res = temp

            for signal in primary_outputs:
                if signal not in dff_inputs:
                    temp = find_out_delay(signal)
                    if temp > res:
                        res = temp

            if res <= max_delay:
                lst.append(y)
                count += 1
                next_size += 1
                area = 0
                for signal in out_generator_gate:
                    area += out_generator_gate[signal][1][1]

                if area < min_area:
                    min_area = area

            if count > x:
                break

        curr_size = next_size

minimum_area_file = open("minimum_area.txt", "w")
minimum_area_file.writelines(str(min_area) + "\n")
minimum_area_file.close()
