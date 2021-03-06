module Core.Mem where

import Clash.Prelude

import Data.Bool

import Core.Decode

doLoad :: MemSize -> Bool -> BitVector 2 -> BitVector 32 -> BitVector 32
doLoad Byte     unsigned lowerAddress memReadValue = bool signExtendImmediate resize unsigned $ (reverse $ unpack memReadValue :: Vec 4 (BitVector 8))  !! lowerAddress
doLoad HalfWord unsigned lowerAddress memReadValue = bool signExtendImmediate resize unsigned $ (reverse $ unpack memReadValue :: Vec 2 (BitVector 16)) !! slice d1 d1 lowerAddress
doLoad Word     _        _            memReadValue = memReadValue

calcWriteStrobe :: MemSize -> BitVector 2 -> BitVector 4
calcWriteStrobe Byte     lowerAddress
    | lowerAddress == 0b00 = 0b0001
    | lowerAddress == 0b01 = 0b0010
    | lowerAddress == 0b10 = 0b0100
    | lowerAddress == 0b11 = 0b1000
calcWriteStrobe HalfWord lowerAddress
    | slice d1 d1 lowerAddress == 0b1 = 0b1100
    | otherwise                       = 0b0011
calcWriteStrobe Word     lowerAddress = 0b1111
