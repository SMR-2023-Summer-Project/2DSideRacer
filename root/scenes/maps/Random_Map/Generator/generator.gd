#Author: Jacob
extends CharacterBody2D

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
const boardWidth = gameWidth / tileSize
const boardHeight = gameHeight / tileSize
var board = zeros(boardWidth, boardHeight)

#Makes a 2d array with all 0's
func zeros(x,y):
	var holderArray = []
	for width in x:
		holderArray.append([])
		for height in y:
			holderArray[width].append(0)
	return holderArray

func _ready():
	print(board)
