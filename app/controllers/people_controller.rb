class PeopleController < ApplicationController
  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])

    success = @person.update(person_params)

    if selected_address_id != @person.mail_address.id
      @person.mail_address = Address.find(selected_address_id)
      @person.save
    end

    if success
      redirect_to next_page
    else
      render :edit
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    redirect_to current_applicant, notice: 'Person removed', status: :see_other
  end

  private

  def selected_address_id
    params[:person] && params[:person][:mail_address_id] || @person.mail_address.id
  end

  def person_params
    params.require(:person).permit(
      :dob,
      :first_name,
      :gender,
      :last_name,
      :middle_name,
      :res_apt,
      :ssn,
      :work_phone,
      :home_phone,
      :cell_phone,
      :preferred_phone,
      :citizenship,
      :nationality,
      :email,
      :race,
      :student_status,
      :marital_status,
      :occupation,
      :state_of_birth,
      :city_of_birth,
      :driver_license_number,
      :driver_license_state,
      mail_address_attributes: [
        :street,
        :city,
        :state,
        :zip,
        :apt,
      ]
    )
  end

  def next_page
    if params[:submit_direction] == "next"
      edit_household_member_path(@current_applicant.household_members.first)
    elsif params[:submit_direction] == "previous"
      @current_applicant
    else
      flash[:notice] = "Saved!"
      edit_person_path(@current_applicant.identity)
    end
  end
end
