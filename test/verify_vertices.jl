using Grid

# Setup test axes that will be shared among the tests
Δ = 0.01
X = [-2:Δ:2]
Y = [-3:Δ:3]

X_c = InterpGrid(X, BCnan, InterpLinear)
Y_c = InterpGrid(Y, BCnan, InterpLinear)

# TEST CASE 1
#
# Contour lines for f(x,y) = x^2 + y^2 lie on circles around the origin
#
Z = [x^2 + y^2 for x in X, y in Y]
# Choose level that is at least on grid size away from origin
h = (Δ + (3 - Δ)rand())
contourlevels = Contour.contours(X,Y,Z, h)
for line in contourlevels.lines
    for v in line.vertices
        @test_approx_eq_eps (X_c[v[1]]^2 + Y_c[v[2]]^2 ) h 0.1Δ
    end
end

# TEST CASE 2
#
# Check that ambigious cells (5, 10) are handled correctly
# Cell Case == 16
Z = [1 0;
     0 1]
h = 0.5

cells = Contour.get_level_cells(Z,h)
@test cells[(1,1)] == 16
lines = Contour.trace_contour(Z, h, cells).lines
@test length(lines) == 2

@test_approx_eq_eps lines[1].vertices[1] [1.0, 1.5] 0.1Δ
@test_approx_eq_eps lines[1].vertices[2] [1.5, 1.0] 0.1Δ

@test_approx_eq_eps lines[2].vertices[1] [2.0, 1.5] 0.1Δ
@test_approx_eq_eps lines[2].vertices[2] [1.5, 2.0] 0.1Δ

# Cell Case == 17
Z = [2 0;
     0 2]
h = 0.5

cells = Contour.get_level_cells(Z,h)
@test cells[(1,1)] == 17
lines = Contour.trace_contour(Z, h, cells).lines
@test length(lines) == 2

@test_approx_eq_eps lines[1].vertices[1] [1.0, 1.75] 0.1Δ
@test_approx_eq_eps lines[1].vertices[2] [1.25, 2.0] 0.1Δ

@test_approx_eq_eps lines[2].vertices[1] [2.0, 1.25] 0.1Δ
@test_approx_eq_eps lines[2].vertices[2] [1.75, 1.0] 0.1Δ

# Cell case == 18
Z = [0 1;
     1 0]

cells = Contour.get_level_cells(Z,h)
@test cells[(1,1)] == 18
lines = Contour.trace_contour(Z, h, cells).lines
@test length(lines) == 2

@test_approx_eq_eps lines[1].vertices[1] [1.5, 2.0] 0.1Δ
@test_approx_eq_eps lines[1].vertices[2] [1.0, 1.5] 0.1Δ

@test_approx_eq_eps lines[2].vertices[1] [1.5, 1.0] 0.1Δ
@test_approx_eq_eps lines[2].vertices[2] [2.0, 1.5] 0.1Δ


# Cell Case == 19
Z = [0 2;
     2 0]

cells = Contour.get_level_cells(Z,h)
@test cells[(1,1)] == 19
lines = Contour.trace_contour(Z, h, cells).lines
@test length(lines) == 2

@test_approx_eq_eps lines[1].vertices[1] [1.25, 1.0] 0.1Δ
@test_approx_eq_eps lines[1].vertices[2] [1.0, 1.25] 0.1Δ

@test_approx_eq_eps lines[2].vertices[1] [1.75, 2.0] 0.1Δ
@test_approx_eq_eps lines[2].vertices[2] [2.0, 1.75] 0.1Δ
