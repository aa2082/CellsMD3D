/*
 * Cell.h
 *
 *  Created on: Dec 15, 2011
 *      Author: mya
 */

#ifndef CELL_H_
#define CELL_H_

#include "tools.h"
#include "rng.h"
#include "Constants.h"
/*
#define ADDER = 0
#define SIZER = 1
#define TIMER = 2
*/

// Cell structure contains information specific to each cell
struct Cell
{
	Segment Position; 	// a segment has two coordinates p and q for the two vertices of the spherocylinder
	double Length;
	double Radius;
	double GrowthRate;
	DoubleCoord Velocity;
	DoubleCoord AngularVelocity; // now a vector
	DoubleCoord DynFric;
	DoubleCoord StaFric;
	int Type;
	int Ancestor;

	//int growth_mode;	//defines whether cell is either ADDER, SIZER, TIMER
	int p_age = 0;		//p pole age
	int q_age = 0; 		//p pole age
	double InitialLength;
	double Volume; 		//volume of cell
	double Age = 0.0;				//time since cell birth
	std::normal_distribution<> divide_distribution{divide_mean,divide_std_dev};
	double division_threshold = divide_distribution(rng);
};

#endif /* CELL_H_ */
