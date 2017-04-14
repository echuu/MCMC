/**
 * PROJECT 1:  Importance Sampling and Sequential Monte Carlo
 * STATS 202C: MONTE CARLO METHODS FOR OPTIMIZATION
 * Author:     Eric Chuu
 */

import java.util.*;

public class SMC {

	public static void p1() {

		System.out.println("Problem 1 on Homework 1");

	}


	public static void SAW(int n) {

		int[][] grid = new int[n+1][n+1];

		for (int r = 0; r < n+1; r++) {
			for (int c = 0; c < n+1; c++) {
				System.out.print(grid[r][c] + " ");
			}
			System.out.println();
		}


	}

	/*
	 *  simulate a uniform probability distribution
	 *  input possible choices
	 *  return the choice chosen
	 */
	public static void prob(int[] choices) {

		int p;
		int dist = choices.length;

		for (int i = 0; i < 10000; i++) {
			p = new Random().nextInt(dist);
			choices[p]++;
		}

	}


	/**
	 * monte carlo integration
	 * used to appproximate the number of SAWs
	 */
	public double mcIntegrate(int M) {

		double sum = 0;
		int moves = {0, 1, 2, 3, 4}


	 	for (int i = 0; i < M; i++) {
	 		// accummulate 1 / g(x_i)
	 	}

	 	return sum / M;
	}


	public static void main(String[] args) {
		System.out.println("Project 1: Sequential Monte Carlo");

		int[] moves = {0, 0, 0, 0};

		prob(moves);

		for (int i = 0; i < moves.length; i++) {
			System.out.println("Move " + (i+1) + ": " + moves[i]);
		}

	}
}