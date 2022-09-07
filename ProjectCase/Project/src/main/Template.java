package main;

import java.awt.BorderLayout;
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import jess.QueryResult;
import jess.ValueVector;

public class Template extends JFrame{
	
	JPanel mainPanel;
	JTable table;
	String []headerFood = {"Name", "Rating", "Price", "Type"};
	String []headerPlan = {"Name", "Duration", "Price", "Food Name", "Quantity "};
	Vector<Object> rows;
	DefaultTableModel tableModel, tableModel1;
	JScrollPane pane;
	
	
	public Template(){

		mainPanel = new JPanel(new BorderLayout());
		table = new JTable();
		pane = new JScrollPane(table);
		tableModel = new DefaultTableModel(headerFood, 0);
		tableModel1 = new DefaultTableModel(headerPlan, 0);
	
		try {
			QueryResult resPlan = MainEngine.engine.runQueryStar("query-food", new ValueVector());
			QueryResult resFood = MainEngine.engine.runQueryStar("query-foodplan", new ValueVector());
			
			if(resPlan.next()) {
				while(resPlan.next()) {
					/* FILL the blanks string with values from your defquery */
					String planName 		= resPlan.getString("nameFP");
					String planDuration 	= resPlan.getString("duration")+" Day(s)";
					String planPrice 		= "$ " + resPlan.getString("priceFP");
					String planFoodName 	= resPlan.getString("foodName");
					String planFoodQuantity = resPlan.getString("quantity");
					
					rows = new Vector<>();
					
					rows.add(planName);
					rows.add(planDuration);
					rows.add(planPrice);
					rows.add(planFoodName);
					rows.add(planFoodQuantity);
					
					tableModel1.addRow(rows);
				}
			}
			
			else if(resFood.next()) {
				while(resFood.next()) {
					/* FILL the blanks string with values from your defquery */
					String foodName 	= resFood.getString("nameF");
					String foodRating 	= resFood.getString("rating");
					String foodPrice 	= "$" + resFood.getString("priceF");
					String foodType		= resFood.getString("typeF");
					
					
					rows = new Vector<>();
					
					rows.add(foodName);
					rows.add(foodRating);
					rows.add(foodPrice);
					rows.add(foodType);
					
					tableModel.addRow(rows);
				
				}
			}
			else{
				JOptionPane.showMessageDialog(null, "No Recommendation available!");
				this.dispose();
			}
						
			resPlan.close();
			resFood.close();
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		table.setModel(tableModel);
		table.setModel(tableModel1);
		
		setTitle("The Result of Consultation");
		setSize(500, 500);
		setLocationRelativeTo(null);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setVisible(true);
		
		//pane.add(table, 0);
		mainPanel.add(pane);
		add(mainPanel);
		
	}

}
