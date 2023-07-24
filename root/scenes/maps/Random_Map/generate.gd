#Author: Jacob
extends Node2D
var rng = RandomNumberGenerator.new()
var tile = preload("res://root/scenes/maps/Random_Map/Tile.tscn")

#Game parameters
const gameWidth = 400
const gameHeight = 200
const tileSize = 16

#Cave generation parameters
const chanceToStartAlive = 0.380
const chanceOfWall = 0.01
const deathLimit = 3
const birthLimit = 4
const simulationNum = 20

#Board parameters
const boardWidth = int(gameWidth / tileSize)
const boardHeight = int(gameHeight / tileSize)
var board = zeros(boardWidth, boardHeight)

#starting and ending generation
var start = [randi_range(1,boardWidth*0.1)]
var end = [randi_range(boardWidth*0.9,boardWidth-1)]
func generateStartAndEnd():
	#generating starting y
	for startXLevel in range(0,boardWidth): #fail safe incase the col is all wall
		var generated = false
		for startYLevel in range(boardHeight-2,0,-1):
			if (board[startXLevel][startYLevel]!=1 and board[startXLevel][startYLevel+1]==1):
				start = [startXLevel,startYLevel]
				generated = true
				break
		if generated:
			break
	#generating ending y
	for endXLevel in range(end[0],boardWidth): #fail safe incase the col is all wall
		var generated = false
		for endYLevel in range(1,boardHeight-2):
			if (board[endXLevel][endYLevel]!=1 and board[endXLevel][endYLevel+1]==1):
				end = [endXLevel,endYLevel]
				generated = true
				break
		if generated:
			break

#Makes a 2d array with all 0's
func zeros(x,y):
	var holderArray = []
	for width in x:
		holderArray.append([])
		for height in y:
			holderArray[width].append(0)
	return holderArray

#Initialize the baord randomly
func startBoard():
	for row in boardWidth:
		for col in boardHeight:
			var randomInt = rng.randi_range(0,10000)
			if randomInt < chanceToStartAlive*10000:
				board[row][col] = 1

#Clears board, not really used, but just incase.
func clearBoard():
	for row in boardWidth:
		for col in boardHeight:
			board[row][col] = 0

#Counts number of alive neighbors given a coordinate
func countAliveNeigbors(x,y):
	var count = 0
	for row in range(-1,2):
		for col in range(-1,2):
			var neighborX = x + row
			var neighborY = y + col
			if (row == 0 and col ==0):
				pass
			elif neighborX < 0 or neighborY <0 or neighborX >= boardWidth or neighborY >= boardHeight:
				count += 1
			elif board[neighborX][neighborY] == 1:
				count +=1
	return count

#Cellular automatia
func simulationStep():
	for iterations in simulationNum:
		var randomInt = rng.randi_range(1,10000)
		for row in boardWidth:
			for col in boardHeight:
				var alive = countAliveNeigbors(row,col)
				if (board[row][col] == 1):
					if alive < deathLimit:
						board[row][col] = 0
					else:
						if randomInt > chanceOfWall*10000:
							board[row][col] = 1
				else:
					if alive > birthLimit:
						if randomInt > chanceOfWall*10000:
							board[row][col] = 1
					else:
						board[row][col] = 0

#Gets neighbors of a point and returns as a list, used for DFS
func getNeighbors(x,y):
	var neighbors = []
	for row in range(-1,2):
		for col in range(-1,2):
			var neighborX = x + row
			var neighborY = y + col
			if(row == 0 and col == 0):
				pass
			elif(row==-1 and col==-1):
				pass
			elif(row==-1 and col==1):
				pass
			elif(row==1 and col ==-1):
				pass
			elif(row==1 and col ==1):
				pass
			elif(neighborX >= boardWidth or neighborY >= boardHeight):
				pass
			elif(neighborX < 0 or neighborY < 0):
				pass
			else:
				neighbors.append([neighborX,neighborY])
	return neighbors

#Does a Depth-First search in order to find if the maze is solvable
func doDFS():
	var visited = []
	var stack = []
	
	stack.append(start)
	while stack.size()!=0:
		var element = stack.pop_front()
		if element not in visited:
			visited.append(element)
			for neighbors in getNeighbors(element[0],element[1]):
				if (board[neighbors[0]][neighbors[1]]==0) and (neighbors not in visited):
					stack.append(neighbors)
		if element == end:
			return true
	return false

func drawMap():
	for x in boardWidth:
		for y in boardHeight:
			var piece = tile.instantiate()
			add_child(piece)
			piece.position = Vector2(x*tileSize,y*tileSize)

func _ready():
	startBoard()
	simulationStep()
	generateStartAndEnd()
	while(!doDFS()):
		clearBoard()
		startBoard()
		simulationStep()
		generateStartAndEnd()
	
	
