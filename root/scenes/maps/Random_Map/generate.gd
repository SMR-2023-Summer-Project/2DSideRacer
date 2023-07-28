#Author: Jacob
extends Node2D
var rng = RandomNumberGenerator.new()

const tile = preload("res://root/scenes/maps/Random_Map/Assets/Tile.tscn")
const startTile = preload("res://root/scenes/maps/Random_Map/Assets/start.tscn")
const endTile = preload("res://root/scenes/maps/Random_Map/Assets/end.tscn")
const DFStile = preload("res://root/scenes/maps/Random_Map/Assets/brown.tscn")
var player = preload("res://root/entities/player/player.tscn").instantiate()
const gameHud = preload("res://root/ui/game_hud/game_hud.tscn")
const coinLoad = preload("res://root/multiplayer/coin.gd")
const speedLoad = preload("res://root/multiplayer/SpeedBoost.tscn")
const jumpLoad = preload("res://root/multiplayer/JumpBoost.tscn")

#Change number of entities
const numCoins = 50
const numSpeedBoosts = 4
const numJumpBoosts = 4

#Game parameters
#Change to null if you want random gameWidth and gameHeight for variation
const gameWidth = 9600
const gameHeight = 2400
const tileSize = 48

#Cave generation parameters
const chanceToStartAlive = 0.4
const chanceOfWall = 0.01
const deathLimit = 3
const birthLimit = 4
const simulationNum = 30

#Board parameters
const boardWidth = int(gameWidth / tileSize)
const boardHeight = int(gameHeight / tileSize)
var board = zeros(boardWidth, boardHeight)

func generateRandomGameSize():
	if gameWidth == null and gameHeight == null:
		pass

#starting and ending generation
var start = [randi_range(2,boardWidth*0.1)]
var end = [randi_range(boardWidth*0.9,boardWidth-3)]
func generateStartAndEnd():
	#generating starting y
	for startXLevel in range(1,boardWidth): #fail safe incase the col is all wall
		var generated = false
		for startYLevel in range(boardHeight-4,0,-1):
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

var visitedPath = []
#Does a Depth-First search in order to find if the maze is solvable
func doDFS():
	var visited = []
	var stack = []
	
	stack.append(start)
	while stack.size()!=0:
		var element = stack.pop_back()
		if element not in visited:
			visited.append(element)
			for neighbors in getNeighbors( element[0],element[1]):
				if (board[neighbors[0]][neighbors[1]]==0) and (neighbors not in visited):
					stack.append(neighbors)
		if element == end:
			visitedPath = visited
			return true
	return false

#Draws the tiles on map
func drawMap():
	for x in boardWidth:
		for y in boardHeight:
			if(board[x][y]==1):
				var piece = tile.instantiate()
				piece.position = Vector2(x*tileSize,y*tileSize)
				add_child(piece)
				
	
	#Uncomment this following code if you want the DFS path to be visualized
#	for coord in visitedPath:
#		var b = DFStile.instantiate()
#		b.position = Vector2(coord[0]*tileSize,coord[1]*tileSize)
#		add_child(b)
	
	var s = startTile.instantiate()
	s.position = Vector2(start[0]*tileSize+1, (start[1]+1)*tileSize)
	add_child(s)

	var end_tile = endTile.instantiate()
	end_tile.position = Vector2(end[0]*tileSize, end[1]*tileSize)
	var area = end_tile.get_node("Area2D")
	area.body_entered.connect(goalTouched)
	add_child(end_tile)
	
	for coords in coinCoords:
		var coin = coinLoad.new()
		coin.position = Vector2(coords[0]*tileSize,coords[1]*tileSize)
		add_child(coin)
	
	for coords in speedCoords:
		var speed = speedLoad.instantiate()
		speed.position = Vector2(coords[0]*tileSize,coords[1]*tileSize)
		add_child(speed)
		
	for coords in jumpCoords:
		var jump = jumpLoad.instantiate()
		jump.position = Vector2(coords[0]*tileSize,coords[1]*tileSize)
		add_child(jump)


#Draws border to prevent gaps
func drawBorder():
	#Fills top and bottom wall in
	for index in boardWidth:
		board[index][0] = 1
		board[index][boardHeight-1] = 1
	#fills in left and right
	for index in boardHeight:
		board[0][index] = 1
		board[boardWidth-1][index]=1

#generates board, this will always generate a viable board
func generateBoard():
	#Starts the board randomly
	startBoard()
	#Does cellular atomatia
	simulationStep()
	#Generates start and end points
	generateStartAndEnd()
	#Checks if the map is viable
	while(!doDFS()):
		#If not, clears board and keeps generating new board until something viable
		clearBoard()
		startBoard()
		simulationStep()
		generateStartAndEnd()
	
	drawBorder()
	addCoins()
	addJumpBoosts()
	addSpeedBoosts()
	#addHUD()

#Generates player
func generatePlayer():
	player.position = Vector2(start[0]*tileSize,start[1]*tileSize)
	player.add_to_group("player")
	
	#Sets up camera
	player.get_node("Camera2D").limit_left = 0
	player.get_node("Camera2D").limit_right = gameWidth-tileSize
	player.get_node("Camera2D").limit_top = 0
	player.get_node("Camera2D").limit_bottom = gameHeight-tileSize
	player.get_node("Camera2D").zoom = Vector2(2,2)
	
	Global.updated_respawn(Vector2(start[0]*tileSize,start[1]*tileSize))
	player.update_spawn(Vector2(start[0]*tileSize,start[1]*tileSize))
	player.force_respawn()
	player.name = str(multiplayer.get_unique_id())
	player.changeNumCoins(numCoins)
	add_child(player)

#Only call these when map is fully setup and generated
var coinCoords = []
func addCoins():
	var count = 0
	while count < numCoins:
		var randX = randi_range(1,boardWidth-4)
		var randY = randi_range(1,boardHeight-4)

		if (board[randX][randY] == 0):
			coinCoords.append([randX,randY])
			count += 1

var speedCoords = []
func addSpeedBoosts():
	var count = 0
	while count < numSpeedBoosts:
		var randX = randi_range(1,boardWidth-4)
		var randY = randi_range(1,boardHeight-4)

		if (board[randX][randY] == 0):
			speedCoords.append([randX,randY])
			count += 1

var jumpCoords = []
func addJumpBoosts():
	var count = 0
	while count < numSpeedBoosts:
		var randX = randi_range(1,boardWidth-4)
		var randY = randi_range(1,boardHeight-4)

		if (board[randX][randY] == 0):
			jumpCoords.append([randX,randY])
			count += 1

var marker = null
var hud = null
func addHUD():
	hud = player.get_node("UI").get_node("GameHUD")
	await hud.ready
	marker = hud.create_player_marker("you")
	

func distanceFromGoal():
	var position = player.position
	var startPos = Vector2(start[0],start[1])*tileSize
	var endPos = Vector2(end[0],end[1])*tileSize
	
	var distFromStart = (startPos-endPos).length()
	var distPlayerToEnd = (endPos-position).length()
	
	return distPlayerToEnd/distFromStart

func goalTouched(body):
	if body.is_in_group("player"):
		await hud.show_finished()
		hud.hide_finished()

func _ready():
	generateBoard()
	drawMap()
	var player = get_tree().get_nodes_in_group("Player")
	print(player[0].global_position)
	player[0].position = Vector2(start[0],start[1])*tileSize
	player[0].get_node("Camera2D").limit_left = 0
	player[0].get_node("Camera2D").limit_right = gameWidth-tileSize
	player[0].get_node("Camera2D").limit_top = 0
	player[0].get_node("Camera2D").limit_bottom = gameHeight-tileSize
	player[0].get_node("Camera2D").zoom = Vector2(2,2)
	#generatePlayer()
	


func _process(delta):
#	var dist = 1-distanceFromGoal()
#	marker.set_progress(dist)
	pass


