package us.bliven.symmetrycad;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.TreeMap;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.vecmath.Matrix4d;

import org.biojava.nbio.structure.xtal.SpaceGroup;
import org.biojava.nbio.structure.xtal.SymoplibParser;

/**
 * Hello world!
 *
 */
public class SpaceGroupExtractor 
{
	public static void main( String[] args ) throws IOException
	{
		if( args.length < 1) {
			System.err.println("Requires output filename");
			System.exit(1);
		}
		String filename = args[0];

		TreeMap<Integer, SpaceGroup> spaceGroups = SymoplibParser.getAllSpaceGroups();

		// Output operators
		try(PrintWriter pw = new PrintWriter(Files.newBufferedWriter(
				Paths.get(filename))))
		{
			spaceGroups.entrySet().stream()
			.sorted(Comparator.comparing((e) -> e.getKey()))
			.map((e) -> e.getValue())
			.filter((sg) -> sg.getId() <= 230 ) // Filter out nonstandard frames
			.map((sg) -> spaceGroupString(sg)+"\n")
			.forEach(pw::write);
	
			// Output full list
			List<String> ops = spaceGroups.entrySet().stream()
					.sorted(Comparator.comparing((e) -> e.getKey()))
					.map((e) -> e.getValue())
					.filter((sg) -> sg.getId() <= 230 ) // Filter out nonstandard frames
					.map((sg) -> nameToken(sg))
					.collect(Collectors.toList());
			
			// Make sure we don't have duplicates
			if(ops.stream().distinct().count() != 230) {
				throw new RuntimeException("Duplicate op name");
			}
			
			pw.println();
			pw.println("// All 230 space groups");
			pw.println("space_groups = [");
			pw.print("    ");
			for(int i=0;i<ops.size()-1;i++) {
				pw.print("sg_"+ops.get(i));
				if(i%8 == 7) {
					pw.print(",\n    ");
				} else {
					pw.print(", ");
				}
			}
			pw.print("sg_"+ops.get(ops.size()-1));
			pw.println(" ];");
		}
	}


	private static String spaceGroupString(SpaceGroup spaceGroup) {
		StringBuffer str = new StringBuffer();
		str.append(String.format("// %d. %s (%s)\n",
				spaceGroup.getId(),
				spaceGroup.getShortSymbol(),
				spaceGroup.getBravLattice().getName()));
		String name = "sg_" + nameToken(spaceGroup);
		str.append(name);
		str.append(" = wrap_ops(\n");
		str.append("    [ identity4(),\n");
		for( int i=1;i<spaceGroup.getNumOperators();i++) {
			Matrix4d op = spaceGroup.getTransformation(i);
			str.append(indent(matrixString(op)));
			str.append(", // ");
			str.append(SpaceGroup.getAlgebraicFromMatrix(op));
			str.append("\n");
		}
		str.append("    ]);");
		return str.toString();
	}


	private static String nameToken(SpaceGroup spaceGroup) {
		return spaceGroup.getShortSymbol()
				.replaceAll("\\s", "")
				.replaceAll("-", "_")
				.replaceAll("[()/']","");
	}


	private static String indent(String s) {
		return Pattern.compile("^",Pattern.MULTILINE).matcher(s).replaceAll("    ");
	}


	private static String matrixString(Matrix4d op) {
		StringBuffer str = new StringBuffer();
		DecimalFormat df = new DecimalFormat("0", DecimalFormatSymbols.getInstance(Locale.ENGLISH));
		df.setMaximumFractionDigits(6); //340 = DecimalFormat.DOUBLE_FRACTION_DIGITS

		str.append("[");
		for(int i=0;i<4;i++) {
			str.append("[");
			for(int j=0;j<4;j++) {
				double val = op.getElement(i, j);
				if(val >= 0 ) {
					str.append(" ");
				}

				str.append(df.format(val));

				if(j != 3) {
					str.append(",");
				}
			}
			str.append("]");
			if(i != 3) {
				str.append(",\n ");
			}
		}
		str.append("]");

		return str.toString();
	}
}
