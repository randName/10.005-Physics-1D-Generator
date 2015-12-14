// clear & purple
// hub_slice(cap=true); stator_slice(cover=true);

// blue & red
// hub_slice(cover=true); stator_slice();

// green & orange
// hub_slice(); stator_slice();

// yellow
// hub_slice(center=true); stator_slice(shaft=true);

// preview
// full_assembly();

// FUNCTIONS

module ring(param=[0:60:360]){ for(i=param) rotate(i) children(); }

module acrylic(thick=2,col="White")
{
	color(col,0.4) translate([0,0,-thick/2]) linear_extrude(thick) children();
}

module cyl(d,h) cylinder(d=d,h=h,center=true,$fn=50);

// OBJECTS

module magnet()
{
	color("Silver",1) cyl(8,3);
}

module bobbin()
{
	color("White",0.2) difference()
	{
		cyl(21,10); cyl(6,15);
		difference(){ cyl(22,8); cyl(8,15); }
	}
}

// ACRYLIC

module hub_slice(cover=false,cap=false,center=false)
{
	difference()
	{
		circle(r=( cap ? 14.45 : 17 ),$fn=48);
		for (i=[-1,1]) translate([7.5*i,0]) circle(d=2.03,$fn=24);
		if ( cap || cover )
		{
			square(6.5,true);
		}
		else
		{
			if ( center ){ square([7,12.5],true); } else { circle(r=11,$fn=6); }
			ring() translate([0,13.5]) square([cover?5:8,3.1],true);
		}
	}
}

module stator_slice(cover=false,shaft=false)
{
	bob_t = 12;
	
	difference()
	{
		circle(r=35,$fn=48);
		if ( cover ){ circle(r=14.5,$fn=48); } else { circle(r=25,$fn=48); }
		ring() translate([0,17.5])
		if ( cover )
		{
			translate([0,bob_t/2]) square([18,bob_t],true);
		}
		else
		{
			translate([0,bob_t/2]) offset(r=0.5) intersection()
			{
				square([20,bob_t*2],true); resize([bob_t*4,bob_t]) circle(r=bob_t,$fn=50);
			}
		}
		ring() translate([28.5,0]) circle(d=3,$fn=24);
		if ( cover ) ring([30:120:360]) translate([0,28.5]) circle(d=6,$fn=6);
	}
	if ( shaft ) ring() translate([0,25]) square([5.5,13.5],true);
}

// ASSEMBLIES

module armature_assembly(cover=false)
{
	ring() translate([0,13.5]) rotate([90,0,0]) magnet();
	translate([0,0,-6.02]) acrylic(3,"Blue") hub_slice(cover=true);
	translate([0,0,-3.01]) acrylic(3,"Green") hub_slice();
	acrylic(3,"Yellow") hub_slice(center=true);
	translate([0,0,3.01]) acrylic(3,"Orange") hub_slice();
	translate([0,0,6.02]) acrylic(3,"Red") hub_slice(cover=true);
	if ( cover ) for(i=[-2,2])
	{
		translate([0,0,-9.03]) acrylic(3,"Purple") hub_slice(cap=true);
		translate([0,0,8.51]) acrylic() hub_slice(cap=true);
	}
}

module stator_assembly(bobbins=false, cover=false)
{
	translate([0,0,-6.02]) acrylic(3,"Blue") stator_slice();
	translate([0,0,-3.01]) acrylic(3,"Green") stator_slice();
	acrylic(3,"Yellow") stator_slice(shaft=true);
	translate([0,0,3.01]) acrylic(3,"Orange") stator_slice();
	translate([0,0,6.02]) acrylic(3,"Red") stator_slice();
	if ( cover )
	{
		translate([0,0,-9.03]) acrylic(3,"Purple") stator_slice(cover=true);
		translate([0,0,8.51]) acrylic() stator_slice(cover=true);
	}
	if ( bobbins ) ring() translate([0,22.75]) rotate([90,0,0]) bobbin();
}

module full_assembly()
{
	rotate($t*360) armature_assembly(cover=true);
	stator_assembly(cover=true,bobbins=false);
}
