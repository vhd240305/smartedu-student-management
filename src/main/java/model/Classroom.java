package model;

public class Classroom {

	private int id;
	private String classroomCode;
	private String name;
	private String room;
	private String description;
	private int teacherId;
	private String teacherName;

	public Classroom() {
	}

	public Classroom(int id, String name, String room, String description, int teacherId) {
		this.id = id;
		this.name = name;
		this.room = room;
		this.description = description;
		this.teacherId = teacherId;
	}

	public Classroom(int id, String name, String room, String description) {
		super();
		this.id = id;
		this.name = name;
		this.room = room;
		this.description = description;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getClassroomCode() {
		return classroomCode;
	}

	public void setClassroomCode(String classroomCode) {
		this.classroomCode = classroomCode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getRoom() {
		return room;
	}

	public void setRoom(String room) {
		this.room = room;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(int teacherId) {
		this.teacherId = teacherId;
	}

	public String getTeacherName() {
		return teacherName;
	}

	public void setTeacherName(String teacherName) {
		this.teacherName = teacherName;
	}
}