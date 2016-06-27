// d20 gaming dice

// Copyright (c) 2016 Neil Okamoto
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

k=7;
un=k;
gr=k*0.5*(1+sqrt(5));
sr=k/3;

echo("Size is", 2*gr);

d20_points = [
    [  0,  un,  gr],
    [  0, -un,  gr],
    [  0,  un, -gr],
    [  0, -un, -gr],
    [ un,  gr,   0],
    [-un,  gr,   0],
    [ un, -gr,   0],
    [-un, -gr,   0],
    [ gr,   0,  un],
    [ gr,   0, -un],
    [-gr,   0,  un],
    [-gr,   0, -un],
];

d20_triangles = [
    [ 0,  4,  8],
    [ 0,  5,  4],
    [ 2,  4,  5],
    [ 2,  9,  4],
    [ 4,  9,  8],
    [10,  1,  7],
    [ 1,  6,  7],
    [ 3,  7,  6],
    [ 3, 11,  7],
    [ 7, 11, 10],
    [ 5, 10, 11],
    [ 2, 11,  3],
    [ 2,  3,  9],
    [ 3,  6,  9],
    [ 6,  8,  9],
    [ 1,  8,  6],
    [ 0,  8,  1],
    [ 0,  1, 10],
    [ 0, 10,  5],
    [ 2,  5, 11],
];

d20_sides = [
    "6","2","3","4","5","17","18","19","15","16",
    "11","1","13","14","10","12","20","8","7","9"];

function to_spherical(p) =
    let(rho=sqrt(p[0]*p[0]+p[1]*p[1]+p[2]*p[2]),
        phi=acos(p[2]/rho),
        theta=atan2(p[1],p[0]))
        [rho, phi, theta];

// rotate "20" to face upward
s20 = d20_triangles[16];
spin = to_spherical((d20_points[s20[0]]+d20_points[s20[1]]+d20_points[s20[2]])/3.0);
rotate([0,-spin[1],-spin[2]])
difference() {
    hull()
    for (p=d20_points) {
        // position spheres with axes rotated to point radially
        s=to_spherical(p);
        rho=s[0];
        phi=s[1];
        theta=s[2];
        rotate([0,phi,theta]) translate([0,0,rho]) sphere(r=sr, $fn=16);
    }

    color("gray")
    for (i=[0:19]) {
        f=d20_triangles[i];
        c = (d20_points[f[0]] + d20_points[f[1]] + d20_points[f[2]]) / 3.0;
        n=d20_sides[i];
        s = to_spherical(c);
        rho=s[0];
        phi=s[1];
        theta=s[2];
        rotate([0,phi,theta]) translate([0,0,rho])
        translate([0,0,0.7*sr]) linear_extrude(height=sr)
        text(n, font="Arial:style=Bold",
             size=0.8*k, valign="center", halign="center");
        if (n == "6" || n == "9") {
            rotate([0,phi,theta]) translate([0,0,rho])
            translate([0,-0.4*k,0.5*sr]) linear_extrude(height=sr)
            text("_", font="Arial:style=Bold",
                 size=0.8*k, valign="center", halign="center");
        }
    }
}

//polyhedron(points=d20_points, triangles=d20_triangles);


