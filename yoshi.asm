
; -----------------------------------------
; Add definitions
.enum $0000
.include "def.asm"
.ende
.include "header.asm"
; -----------------------------------------
; Add macros
.include "macros.asm"
; -----------------------------------------
; Add RAM definitions
.enum $0000
.include "src/ram/internal.asm"
.ende

.base $8000
.include "src/bank-0.asm"
.include "src/tail-0.asm"

.base $8000
.include "src/bank-1.asm"
.include "src/tail-0.asm"

.base $8000
.include "src/tail-1.asm"

.base $8000
.include "src/tail-1.asm"

.base $8000
.include "src/tail-1.asm"

.base $8000
.include "src/tail-1.asm"

.base $8000
.include "src/tail-1.asm"

.base $c000
.include "src/bank-7.asm"
.include "src/tail-1.asm"

.include "src/chr.asm"
