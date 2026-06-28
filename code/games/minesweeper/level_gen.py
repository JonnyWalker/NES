from random import randrange
WIDTH = 16
HEIGHT = 12
MINE_NUM = 20
MINE_HEX_VALUE = 10
board = [0]*(WIDTH*HEIGHT)

assert WIDTH>=1
assert HEIGHT>=1
assert MINE_NUM<=WIDTH*HEIGHT

# compute mine positions
indices = [x for x in range(WIDTH*HEIGHT)]
mine_positions = []
for i in range(MINE_NUM):
    pos = randrange(len(indices))
    indices.pop(pos)
    mine_positions.append(pos)

# place mine positions
for i in mine_positions:
    board[i] = MINE_HEX_VALUE

# compute numbers
for i in range(len(board)):
    if board[i] == MINE_HEX_VALUE:
        continue
    
    # compute possible positions (also handles spec. cases)
    # p0 p1 p2
    # p3  i p4
    # p5 p6 p7
    positions = []
    if i % WIDTH !=0: 
        p0 = i-WIDTH-1
        if p0 >= 0:
            positions.append(p0)
        p3 = i-1
        if p3 >= 0:
            positions.append(p3)
        p5 = i+WIDTH-1
        if p5 < WIDTH*HEIGHT:
            positions.append(p5)
    if i % WIDTH != WIDTH-1:
        p2 = i-WIDTH+1
        if p2 >= 0:
            positions.append(p2)
        p4 = i+1
        if p4 < WIDTH*HEIGHT:
            positions.append(p4)
        p7 = i+WIDTH+1
        if p7 < WIDTH*HEIGHT:
            positions.append(p7)
    p1 = i-WIDTH
    if p1 >= 0:
        positions.append(p1)
    p6 = i+WIDTH
    if p6 < WIDTH*HEIGHT:
        positions.append(p6)
    # check all positions for mine
    mine_counter = 0
    for p in positions:
        if board[p]==MINE_HEX_VALUE:
            mine_counter +=1
    # change number
    board[i] = mine_counter

# print game (ca65 syntax)
index = 0
while index<WIDTH*HEIGHT:
    if index % WIDTH == 0:
        print()
        print(".byte ", end='')
    hex_value = hex(board[index])[2:]
    print(f"$0{hex_value},", end='')
    index += 1
print()
